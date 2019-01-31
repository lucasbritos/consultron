let getData = async () =>{
  var url = new URL(window.location.href);
  var project = url.searchParams.get("project");
  var location = url.searchParams.get("location");
  const response = await fetch('http://'+window.location.host+'/api/apps/5?project='+project)
  let data = await response.json();


  // filtramos por location
  if (location) { data = data.filter(r => (r.location == location)) }
 
  return Promise.resolve(data)
}

getData().then(function (data){
  
  console.log(data)
  // TODO: FILTER

  links = data.map(function(row){
    return {
      target: row.target,
      source: row.source
      }
    })

  for (link of links){
    link.source = nodes[link.source] || (nodes[link.source] = {name: link.source});
    link.target = nodes[link.target] || (nodes[link.target] = {name: link.target});
  }

  nodes = d3.values(nodes);
  console.log(links)
  console.log(nodes)
  start()

})

var nodes = {};
var links = [];

var width = 960;
var height = 600;

var simulation = d3.forceSimulation()
	.force("link", d3.forceLink().distance(60))
	.force("charge", d3.forceManyBody().strength(-600))
	.force("x", d3.forceX(width/2))
	.force("y", d3.forceY(height/2))
	.on("tick", tick);

var svg = d3.select("svg")


function tick() {
	var nodeElements = svg.selectAll(".node");
	var linkElements = svg.selectAll(".link");
	var textElements = svg.selectAll(".text");
	nodeElements.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });


	linkElements
		.attr("x1", function(d) { return d.source.x; })
		.attr("y1", function(d) { return d.source.y; })
		.attr("x2", function(d) { return d.target.x; })
		.attr("y2", function(d) { return d.target.y; });
}

function start() {

	var nodeElements = svg.selectAll(".node")
		.data(nodes, function(d){return d.name})
		
	var linkElements = svg.selectAll(".link").data(links, function(d) { return d.source.name + "-" + d.target.name; });

	nodeElements.exit().remove();
	linkElements.exit().remove();



	var g = nodeElements.enter()
		.append("g")
		.attr("class", "node").merge(nodeElements)
		.call(d3.drag()
           	.on("start", dragstarted)
           	.on("drag", dragged)
           	.on("end", dragended))
    	.on("dblclick", dblclick)
		.on("contextmenu", contextMenu);


	g.append("circle").attr("class", "circle").attr("r", 11);
	g.append("text")
		.attr("class", "text")
		.attr("dx", 12)
       	.attr("dy", ".35em")
       	.text(function(d) { return d.name; });

	linkElements.enter().insert("line", ".node").attr("class", "link").merge(linkElements);

	simulation.nodes(nodes)
	simulation.force("link").links(links)
	simulation.alpha(1).restart();
}


function dragstarted(d) {
	if (!d3.event.active) simulation.alphaTarget(0.3).restart();
	d.fx = d.x;
	d.fy = d.y;
}

function dragged(d) {
	d.fx = d3.event.x;
	d.fy = d3.event.y;
}

function dragended(d) {
	if (!d3.event.active) simulation.alphaTarget(0);
}


function dblclick(d) {
	if (!d3.event.active) simulation.alphaTarget(0);
	d.fx = null;
	d.fy = null;
}

function contextMenu(d, i) {
	if (!d3.event.active) simulation.alphaTarget(0);
	d3.event.preventDefault();
	nodes.splice(i,1);
    nodes = nodes.filter(function(e){
    	return e.name !== d.name;
	});

	links = links.filter(function(l) {
    	return l.source !== d && l.target !== d;
    });

	start();
	d3.event.stopPropagation();
}

