var fs = require ('file-system')

// Ouput EDH geo gazetteer
fs.readFile('./edhGeographicData.json', function(err, edh) {
	if(err) { console.log(err); }
  var edhJson = JSON.parse(edh);
  var ids = '';

  edhJson.features.forEach(function(p, i) {
		if (p.properties && p.properties.inscriptions && p.properties.id) {
      p.properties.inscriptions.forEach(function(ins, i) {
				ids += '"' + ins + '","' + p.properties.id + '"\n'
		  });
		}
	})

  fs.writeFile('./edh_geo_id.csv', ids, function(err, success) {
		console.log('success');
	});
})
