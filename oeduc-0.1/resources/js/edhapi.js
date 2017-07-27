
        $(document).on('ready', function () {
        var value = $('.EDH').text()
        
        var url = 'http://edh-www.adw.uni-heidelberg.de/data/api/inscriptions/search?hd_nr='
        
        var apicall = url + value
        $.getJSON(apicall, function (data) {
        console.log(data)
        var people = data.items["0"].people
        var names = ""
        for (var t = 0; t < people.length; t++){
        var n = t + 1
        var name = '<div class="row"><div  class="col-md-2">' + 'person '+ n + '</div><div class="col-md-2">' + people[t].name + '</div>' + '<div class="col-md-2">' + people[t].nomen + '</div>' +  '<div class="col-md-2">' + people[t].cognomen + '</div>'+  '<div class="col-md-2">' + people[t].status + '</div>' + '<div class="col-md-2">' + people[t].gender + '</div></div>'
        names += name
        }
        $("#edhapi").html(names)
        });
        
        });