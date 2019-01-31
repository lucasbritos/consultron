let getData = async () =>{
	var url = new URL(window.location.href);
	var project = url.searchParams.get("project");
	var location = url.searchParams.get("location");
	const response = await fetch('http://'+window.location.host+'/api/apps/4?project='+project)
	let data = await response.json();
  
  
	// filtramos por location
	if (location) { data = data.filter(r => (r.location == location)) }
   
	return Promise.resolve(data)
}
  
getData().then(function (data){
  
	table(data)
  
})




function table(rows){
	console.log(rows);

	var table = $('<table id="tabla"</table>');

	var sample = rows[0]

	var headerArray = [];
	for (var key in sample) { if (sample.hasOwnProperty(key)) headerArray.push(key) }



	var header = "<tr>"
	headerArray.forEach(key=>{ header += `<th>${key}</th>` 	})
	
	header += "</tr>"

	table.append(header)
	console.log(headerArray)
	
	for (var i =0; i<rows.length; i++){
		var row = "<tr>"
		headerArray.forEach(key=>{ row += `<td>${rows[i][key]}</td>` 	})
		row += "</tr>"
		table.append(row)
	}

	$('#page').append(table);
	$("html").css("cursor", "default");
}









