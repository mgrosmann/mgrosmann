<div id="Description"><h2>Pergolas:</h2>
 Avec gestion d’ombrage, toiture fixe ou encore à lames, découvrez toute notre gamme de pergolas bioclimatiques et apportez une réelle plus-value à votre terrasse.
Pergabri transforme vos rêves en réalité en vous proposant diverses pergolas bioclimatiques à la fois innovantes et esthétiques.
Retrouvez un large choix de pergolas, personnalisables avec plusieurs options et coloris afin de créer l’espace extérieur qui vous correspond.
</div>
<div id="Produits">
    <img src="image/image-usine-1.jpg" width="175" height="175"/>
     <p>Pergola bioclimatique à lames Blade-Perg:</p>
   <select id="mySelect" onchange="showOptions()">
        <option value="0">Selectionnez une option</option>
        <option value="1">Pergola bioclimatique à lames Blade-Perg</option>
        <option value="2">Pergola bioclimatique Sky-Perg</option>
        <option value="3">Pergola Shade-Perg</option>
        
        
    </select>
    <p>Pergola bioclimatique à lames Blade-Perg:</p>
<img src="image/image-usine-1.jpg" width="175" height="175"/>
<select id="mySelect" onchange="showOptions()">
        <option value="0">Selectionnez une option</option>
        <option value="1">Pergola bioclimatique à lames Blade-Perg</option>
        <option value="2">Pergola bioclimatique Sky-Perg</option>
        <option value="3">Pergola Shade-Perg</option>
        
        
    </select>






    <div id="conditionalOptions" style="display: none;">
        <p>Pergola bioclimatique à lames Blade-Perg:</p>
        <select>
            <option value="A">Selectionnez une taille </option>
            <option value="B">3m x 3m </option>
            <option value="C">4m x 3m</option>
            <option value="D">4m x 4m</option>
            <option value="E">6m x 3m</option>
            <option value="F">8m x 4m</option>
        </select>
    </div>
 <div id="conditionalOptions1" style="display: none;">
        <p>Pergola bioclimatique Sky-Perg :</p>
        <select>
            <option value="G">Selectionnez une taille </option>
            <option value="H">3m x 3m </option>
            <option value="I">4m x 3m</option>
            <option value="J">4m x 4m</option>
            <option value="K">6m x 3m</option>
            <option value="L">8m x 4m</option>
        </select>
    </div>
    <div id="conditionalOptions2" style="display: none;">
        <p>Pergola Shade-Perg :</p>
        <select>
            <option value="K">3m x 3m </option>
            <option value="L">4m x 3m</option>
            <option value="M">4m x 4m</option>
            <option value="N">6m x 3m</option>
            <option value="O">8m x 4m</option>
        </select>
    </div>
    <script>
        function showOptions() {
            var select = document.getElementById("mySelect");
            var conditionalOptions = document.getElementById("conditionalOptions");
            var conditionalOptions1 = document.getElementById("conditionalOptions1");
            var conditionalOptions2 = document.getElementById("conditionalOptions2");
            var selectedValue = select.value;
           

            if (selectedValue === "1") {
                conditionalOptions1.style.display = "none";
                conditionalOptions2.style.display = "none";
                conditionalOptions.style.display = "block";
            } else  if (selectedValue === "2"){
                conditionalOptions.style.display = "none";
                conditionalOptions2.style.display = "none";
                conditionalOptions1.style.display = "block";
            } else if (selectedValue === "3"){
                conditionalOptions.style.display = "none";
                conditionalOptions1.style.display = "none";
                conditionalOptions2.style.display = "block";
            } else {
                conditionalOptions.style.display = "none";
                conditionalOptions1.style.display = "none";
                conditionalOptions2.style.display = "none";
                
            }
        }
    </script>

</div>