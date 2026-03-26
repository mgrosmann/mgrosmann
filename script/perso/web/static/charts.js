// Gestion globale des instances de graphiques
let charts = { decade: null, artist: null, album: null, daily: null, evolution: null };

// Palette de 15 couleurs distinctes
const CHART_COLORS = [
    '#1DB954', '#1ed760', '#53d669', '#81ed99', '#2e77d0', 
    '#4593f3', '#72aeff', '#ff5a5f', '#ff7e82', '#ffb3ba',
    '#ffcc33', '#ffe066', '#bd93f9', '#d6bbfa', '#ffffff'
];

async function loadAllStats() {
    const { start, end } = getTimeFilters();
    try {
        const res = await fetch(`/api/stats?start=${start}&end=${end}`);
        const data = await res.json();

        // 1. Courbe d'activité globale (Verte)
        if (data.daily_scrobbles) {
            renderDailyScrobblesChart('dailyScrobblesChart', data.daily_scrobbles);
        }

        // 2. Évolution Top 15 Artistes (Multi-lignes)
        if (data.artist_evolution) {
            renderArtistEvolutionChart('artistEvolutionChart', data.artist_evolution);
        }

        // 3. Répartition par Décennies
        renderDecadeChart(data.decades);
        
        // 4. Top 20 Artistes & Albums
        renderSimpleChart('artistChart', data.top_artists, 'Écoutes', 'artist', true);
        renderSimpleChart('albumChart', data.top_albums, 'Écoutes', 'album', true);
        
    } catch (e) { 
        console.error("Erreur stats:", e); 
    }
}

function renderArtistEvolutionChart(id, evolutionData) {
    const canvas = document.getElementById(id);
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (charts.evolution) charts.evolution.destroy();

    const labels = [...new Set(evolutionData.map(d => d.day))].sort();
    const groups = evolutionData.reduce((acc, curr) => {
        if (!acc[curr.name]) acc[curr.name] = {};
        acc[curr.name][curr.day] = curr.count;
        return acc;
    }, {});

    const datasets = Object.keys(groups).slice(0, 15).map((artist, i) => ({
        label: artist.replace(/'/g, ""),
        data: labels.map(day => groups[artist][day] || 0),
        borderColor: CHART_COLORS[i % CHART_COLORS.length],
        backgroundColor: CHART_COLORS[i % CHART_COLORS.length],
        tension: 0.3,
        pointRadius: 0,
        pointHoverRadius: 5, // Fait apparaître un point au survol
        borderWidth: 2
    }));

    charts.evolution = new Chart(ctx, {
        type: 'line',
        data: { labels, datasets },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                mode: 'nearest', // Détecte la ligne la plus proche de la souris
                intersect: false
            },
            plugins: {
                legend: { position: 'bottom', labels: { color: '#888', font: { size: 9 } } },
                tooltip: {
                    enabled: true,
                    backgroundColor: 'rgba(0, 0, 0, 0.9)',
                    titleColor: '#1DB954',
                    bodyColor: '#fff',
                    padding: 10,
                    borderColor: 'rgba(255,255,255,0.1)',
                    borderWidth: 1,
                    displayColors: true, // Affiche le petit carré de couleur de l'artiste
                    callbacks: {
                        // C'est ici qu'on définit l'affichage au survol
                        label: function(context) {
                            let label = context.dataset.label || '';
                            if (label) {
                                label += ' : ';
                            }
                            if (context.parsed.y !== null) {
                                label += context.parsed.y + ' écoutes';
                            }
                            return label; // Affichera par ex: "Werenoi : 12 écoutes"
                        }
                    }
                }
            },
            scales: {
                y: { grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#888' } },
                x: { grid: { display: false }, ticks: { color: '#888', maxRotation: 45 } }
            }
        }
    });
}

function renderDailyScrobblesChart(id, dailyData) {
    const canvas = document.getElementById(id);
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (charts.daily) charts.daily.destroy();

    charts.daily = new Chart(ctx, {
        type: 'line',
        data: {
            labels: dailyData.map(d => {
                const date = new Date(d.day);
                return date.toLocaleDateString('fr-FR', { 
                    weekday: 'short', 
                    day: 'numeric', 
                    month: 'short' 
                });
            }),
            datasets: [{
                label: 'Écoutes',
                data: dailyData.map(d => d.count),
                borderColor: '#1DB954',
                backgroundColor: 'rgba(29, 185, 84, 0.1)',
                fill: true,
                tension: 0.4,
                pointRadius: 3,
                pointHoverRadius: 6, // Agrandit le point au survol
                borderWidth: 3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                mode: 'index',
                intersect: false, // Permet d'afficher le tooltip même si on n'est pas pile sur le point
            },
            plugins: { 
                legend: { display: false },
                tooltip: {
                    enabled: true,
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleColor: '#1DB954',
                    bodyColor: '#fff',
                    padding: 10,
                    displayColors: false,
                    callbacks: {
                        label: function(context) {
                            return ` 🎧 ${context.parsed.y} écoutes`;
                        }
                    }
                }
            },
            scales: {
                y: { 
                    beginAtZero: true, 
                    grid: { color: 'rgba(255,255,255,0.05)' }, 
                    ticks: { color: '#888' } 
                },
                x: { 
                    grid: { display: false }, 
                    ticks: { color: '#888' } 
                }
            }
        }
    });
}

function renderDecadeChart(items) {
    const canvas = document.getElementById('decadeChart');
    if (!canvas || !items) return;
    const ctx = canvas.getContext('2d');
    if (charts.decade) charts.decade.destroy();

    charts.decade = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: items.map(i => i.name),
            datasets: [{ label: 'Écoutes', data: items.map(i => i.count), backgroundColor: '#1DB954', borderRadius: 5 }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            onClick: (e, el) => {
                if (el.length > 0) showDecadeDetails(items[el[0].index].name);
            },
            scales: {
                y: { beginAtZero: true, ticks: { color: '#fff' } },
                x: { ticks: { color: '#fff' } }
            },
            plugins: { legend: { display: false } }
        }
    });
}

function renderSimpleChart(id, items, label, type, isHorizontal = false) {
    const canvas = document.getElementById(id);
    if (!canvas || !items) return;
    const ctx = canvas.getContext('2d');
    
    // Détruire l'ancien graphique s'il existe
    if (charts[type]) charts[type].destroy();

    charts[type] = new Chart(ctx, {
        type: 'bar', // Définit le type de graphique
        data: {
            labels: items.map(item => item.name),
            datasets: [{ 
                label: label, 
                data: items.map(item => item.count), 
                backgroundColor: '#1DB954',
                borderRadius: 5,
                // On stocke les projets ici pour les récupérer dans le tooltip
                projects: items.map(item => item.detail || '') 
            }]
        },
        options: {
            indexAxis: isHorizontal ? 'y' : 'x',
            responsive: true,
            maintainAspectRatio: false,
            plugins: { 
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        // Affiche les détails au survol
                        afterBody: function(context) {
                            const detail = context[0].dataset.projects[context[0].dataIndex];
                            if (!detail || detail === '') return '';
                            
                            // Transforme la chaîne "Projet A (10) | Projet B (5)" en lignes
                            const albumList = detail.split(' | ');
                            return ['', '🔥 TOP 10 PROJETS :', ...albumList];
                        }
                    }
                }
            },
            scales: {
                x: { 
                    grid: { display: false }, 
                    ticks: { color: '#b3b3b3' } 
                },
                y: { 
                    grid: { color: 'rgba(255,255,255,0.1)' }, 
                    ticks: { color: '#b3b3b3' } 
                }
            }
        }
    });
}
async function showDecadeDetails(decadeName) {
    const { start, end } = getTimeFilters();
    const container = document.getElementById("decade-details");
    
    // Transforme "2010s" en "2010"
    const decadeValue = decadeName.replace('s', ''); 
    
    container.innerHTML = `<h3 style="color:white; margin-top:20px;">🏆 Top Albums des années ${decadeValue}</h3>
                           <div class="loading" style="color:#aaa;">Chargement des pépites...</div>`;

    try {
        // Envoi de la requête avec le paramètre decade
        const res = await fetch(`/api/albums?start=${start}&end=${end}&decade=${decadeValue}`);
        const data = await res.json();
        
        // On s'assure que data est un tableau
        const albums = Array.isArray(data) ? data : (data.items || []);

        if (albums.length === 0) {
            container.innerHTML = `<p style="color:gray;">Aucun album trouvé pour cette période.</p>`;
            return;
        }

        let html = `<div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(130px, 1fr)); gap: 15px; margin-top:15px;">`;
        
        albums.slice(0, 12).forEach(item => {
            // Utilise tes fonctions de formatage habituelles
            const img = (typeof formatImgUrl === 'function') ? formatImgUrl(item.album_img) : item.album_img;
            const name = (typeof formatName === 'function') ? formatName(item.name) : item.name;

            html += `
                <div class="card-mini" style="text-align:center; background: rgba(255,255,255,0.05); padding: 10px; border-radius: 8px;">
                    <img src="${img}" style="width: 100%; aspect-ratio: 1/1; object-fit: cover; border-radius: 4px;">
                    <div style="font-size: 0.85em; color:white; margin-top:8px; font-weight:bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                        ${name}
                    </div>
                    <div style="font-size: 0.75em; color:#1DB954;">${item.count} écoutes</div>
                </div>`;
        });
        
        container.innerHTML = html + "</div>";
        container.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

    } catch (e) { 
        console.error("Erreur détails décennie:", e);
        container.innerHTML = "<p style='color:red;'>Erreur lors du chargement des détails.</p>";
    }
}
