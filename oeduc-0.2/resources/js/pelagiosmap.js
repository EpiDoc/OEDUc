$(document).ready(function() {
 var Input = $('.pleiades').text()
 var queryInput = Input.replace(/\s/g, '')
  /************************************************************************************************/
  /** A quick hack to display the convex hulls from Pelagios API search results on a Leaflet map **/
  /** Licensed under the terms of the WTFPL http://www.wtfpl.net/                                **/
  /************************************************************************************************/

  var awmcLayer = L.tileLayer('http://a.tiles.mapbox.com/v3/isawnyu.map-knmctlkh/{z}/{x}/{y}.png', {
        attribution: 'Tiles and Data &copy; 2013 <a href="http://www.awmc.unc.edu" target="_blank">AWMC</a> ' +
                     '<a href="http://creativecommons.org/licenses/by-nc/3.0/deed.en_US" target="_blank">CC-BY-NC 3.0</a>'}),

      dareLayer = L.tileLayer('http://pelagios.org/tilesets/imperium//{z}/{x}/{y}.png', {
        attribution: 'Tiles: <a href="http://imperium.ahlfeldt.se/">DARE 2014</a>',
        minZoom:3,
        maxZoom:11
      }),

      baseLayers =
        { 'Empty Basemap (<a href="http://awmc.unc.edu/wordpress/tiles/map-tile-information" target="_blank">AWMC</a>)': awmcLayer,
          'Roman Empire Basemap (<a href="http://imperium.ahlfeldt.se/" target="_blank">DARE</a>)': dareLayer },

      /** Defines the map **/
      map = new L.Map('pelagios', {
        center: new L.LatLng(41.893588, 12.488022), // Rome
        zoom: 3,
        layers: [awmcLayer]
      }),

      /** A shortcut to create a nicer shape drawing style than Leaflet's default **/
      createDrawingStyle = function(color) {
        return {
          color: color,
          weight: 1,
          fillOpacity: 0.3,
          opacity: 0.6
        };
      },

      /** This is the key function: fetches data from the Pelagios API and plots it on the map **/
      queryPelagiosAPI = function(query, limit, style) {
        // Note: 'verbose=true' ensures we get the convex hulls, too, not just the bounding boxes
        jQuery.getJSON('http://pelagios.org/peripleo/search?places=http:%2F%2Fpleiades.stoa.org%2Fplaces%2F' + query + '&limit=' + limit + '&verbose=true&type=item', function(data) {
          // Loop through all result items, and plot the convex hull if the item has one
          jQuery.each(data.items, function(idx, item) {
            if (item.geometry) {
              var shape = L.geoJson(item.geometry, style).addTo(map);
              shape.bindPopup(item.title);
            }
          });
        });
      };

  map.addControl(new L.Control.Layers(baseLayers));

  // As an example, we fetch the results for the queries 'Homer' and 'Herodotus' an draw them in different colours
  queryPelagiosAPI(queryInput, 100, createDrawingStyle('#009933'));
  //queryPelagiosAPI('herodotus', 100, createDrawingStyle('#990000'));

});