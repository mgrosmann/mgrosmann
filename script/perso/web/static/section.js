/**
 * Construit la liste des cartes (Cards) dans le container
 */
function renderList(data) {
    const container = document.getElementById("content-list");
    if (!container) return;
    container.innerHTML = "";

    data.items.forEach((item, index) => {
        const div = document.createElement("div");
        div.className = "card";
        
        let displayTitle = formatName(item.name);
        let displaySubtitle = formatName(item.artist || "");
        let img = formatImgUrl(item.album_img);
        let info = item.timestamp ? 
            new Date(item.timestamp * 1000).toLocaleString() : 
            `${item.count} écoutes`;

        div.innerHTML = `
            <div class="rank">#${((currentPage - 1) * 50) + index + 1}</div>
            <img src="${img}" onerror="this.src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRA9a1UrwQrvGIMu_w7cjAYW7aJz5ZIhvv90g&s.jpg'">
            <div class="info">
                <div class="title">${displayTitle}</div>
                <div class="subtitle">${displaySubtitle} (${info})</div>
            </div>
        `;
        
        // Navigation intelligente au clic
        const rawName = item.name.replace(/^'|'$/g, "");
        if (currentView === "artists") {
            div.onclick = () => filterByArtist(rawName);
        } else if (currentView === "albums") {
            div.onclick = () => filterByAlbum(rawName);
        }
        
        container.appendChild(div);
    });
}

/**
 * Affiche ou masque la carte "Now Playing"
 */
function renderNowPlaying(data) {
    const container = document.getElementById('now-playing-container');
    if (!container) return;

    if (data.active) {
        const imgUrl = formatImgUrl(data.image);
        container.innerHTML = `
            <div class="now-playing-card" style="display: flex; align-items: center; gap: 15px; background: rgba(255,255,255,0.05); padding: 12px; border-radius: 10px; border: 1px solid rgba(255,255,255,0.1);">
                <img src="${imgUrl}" alt="Cover" style="width: 55px; height: 55px; border-radius: 6px; object-fit: cover; box-shadow: 0 4px 10px rgba(0,0,0,0.3);">
                <div style="flex-grow: 1;">
                    <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 4px;">
                        <span class="pulse-icon" style="font-size: 10px;">🔴</span>
                        <span style="font-size: 10px; font-weight: bold; letter-spacing: 1px; color: #ff4d4d;">EN DIRECT</span>
                    </div>
                    <b style="font-size: 1.1em; color: #fff;">${data.track}</b><br>
                    <small style="color: #bbb;">${data.artist} — <i style="color: #888;">${data.album}</i></small>
                </div>
            </div>
        `;
        container.style.display = 'block';
    } else {
        container.style.display = 'none';
    }
}

/**
 * Gère la navigation entre les onglets (Artistes, Albums, etc.)
 */
function showSection(section) {
    currentView = section;
    currentPage = 1;
    
    // On cache tout, on montre la bonne section
    const listContainer = document.getElementById("content-list");
    const statsContainer = document.getElementById("stats-container");
    const pagination = document.getElementById("pagination");

    if (section === "stats") {
        listContainer.style.display = "none";
        pagination.style.display = "none";
        statsContainer.style.display = "block";
        loadAllStats();
    } else {
        listContainer.style.display = "grid";
        pagination.style.display = "flex";
        statsContainer.style.display = "none";
        loadData();
    }
}

/**
 * Filtres rapides
 */
function filterByArtist(name) {
    currentArtist = name; 
    currentView = "albums";
    currentPage = 1;
    loadData();
}

function filterByAlbum(name) {
    currentAlbum = name;
    currentView = "tracks";
    currentPage = 1;
    loadData();
}

/**
 * Pagination
 */
function renderPagination(data) {
    const nav = document.getElementById("pagination");
    if (!nav) return;
    nav.innerHTML = `
        <button onclick="changePage(-1)" ${data.current_page <= 1 ? 'disabled' : ''}>Précédent</button>
        <span>Page ${data.current_page} / ${data.total_pages}</span>
        <button onclick="changePage(1)" ${data.current_page >= data.total_pages ? 'disabled' : ''}>Suivant</button>
    `;
}

function changePage(step) {
    currentPage += step;
    loadData();
}
