---
layout: post
title: "D3js map test"
---
Here I am trying to replicate an example from M. Bostock D3js tutorial

<style>

text {
  font: bold 48px monospace;
}

.enter {
  fill: green;
}

.update {
  fill: #333;
}

.exit {
  fill: brown;
}

</style>

<svg width="960" height="500"></svg>

<script src="https://d3js.org/d3.v4.min.js"></script>

<script>

var alphabet = "abcdefghijklmnopqrstuvwxy".split("");

var svg = d3.select("svg");

var width = svg.attr("width"),
		height = svg.attr("height");

g = svg.append("g")
	.attr("transform", "translate(32, " + height/2 + ")");

function update(data){
	var t = d3.transition()
			.duration(750);

	//new data join, using key
	var text = g.selectAll("text")
			.data(data, d => d);

	//exit - old elements not present in the new data
	text.exit()
			.attr("class", "exit")
		.transition(t)
			.attr("y", 60)
			.style("fill-opacity", 1e-6)
			.remove();
	
	//update
	text.attr("class", "update")
			.attr("y", 0)
			.style("fill-opacity", 1)
		.transition(t)
			.attr("x", (d, i) => 32*i);

	//enter
	text.enter().append("text")
			.attr("class", "enter")
			.attr("dy", ".35em")
			.attr("y", -60)
			.attr("x", (d, i) => 32*i)
			.style("fill-opacity", 1e-6)
			.text(d => d)
		.transition(t)
			.attr("y", 0)
			.style("fill-opacity", 1);
	
}

update(alphabet);

d3.interval(function() {
	update(d3.shuffle(alphabet)
		.slice(0, Math.floor(Math.random() * 26))
		.sort());
}, 1500);

</script>