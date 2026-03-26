// État global de l'application
let currentView = "artists";
let currentPage = 1;
let currentArtist = null;
let currentAlbum = null;

/**
 * Formate les noms (nettoyage des quotes et séparateurs)
 */
function formatName(text) {
    if (!text) return "";
    let cleaned = text.replace(/^'|'$/g, "");
    return cleaned.replace(/;/g, " & ");
}

/**
 * Gère l'URL de l'image avec fallback par défaut
 */
function formatImgUrl(url) {
    const defaultImg = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRA9a1UrwQrvGIMu_w7cjAYW7aJz5ZIhvv90g&s.jpg";
    if (!url || url === "null" || url === "''" || url === "") return defaultImg;
    return url.replace(/^'|'$/g, "").trim();
}

/**
 * Récupère les filtres temporels du DOM
 */
function getTimeFilters() {
    const startInput = document.getElementById("startDate")?.value;
    const endInput = document.getElementById("endDate")?.value;
    return {
        start: startInput ? Math.floor(new Date(startInput).getTime() / 1000) : "",
        end: endInput ? Math.floor(new Date(endInput).getTime() / 1000) : ""
    };
}

/**
 * Cœur du système : charge les données selon la vue et les filtres
 */
async function loadData() {
    const { start, end } = getTimeFilters();
    let url = `/api/${currentView}?page=${currentPage}&start=${start}&end=${end}`;
    
    if (currentArtist) url += `&artist=${encodeURIComponent(currentArtist)}`;
    if (currentAlbum) url += `&album=${encodeURIComponent(currentAlbum)}`;

    try {
        const res = await fetch(url);
        const data = await res.json();
        renderList(data); // Appelle la fonction d'affichage située dans section.js
        renderPagination(data);
        document.getElementById("total-count").innerText = `${data.total_count} éléments`;
    } catch (e) {
        console.error("Erreur chargement :", e);
    }
}

/**
 * Vérifie si une musique est écoutée en direct
 */
async function checkNowPlaying() {
    try {
        const response = await fetch('/api/now_playing');
        const data = await response.json();
        renderNowPlaying(data); // Appelle la fonction d'affichage située dans section.js
    } catch (e) {
        console.error("Erreur Now Playing JS:", e);
    }
}

// Initialisation
window.onload = () => {
    loadData();
    checkNowPlaying();
    setInterval(checkNowPlaying, 50000);
};
