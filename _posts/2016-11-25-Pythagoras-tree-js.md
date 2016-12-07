---
layout: post
title: "Pythagorean Broccoli with D3"
date:   2016-11-22 23:06:00
last_modified_at:  2016-11-22 23:06:00
excerpt: "D3 rendering of randomized Pythagorean tree fractal, constantly morphing into new shapes"
categories: visualization
tags:  D3, fractal, visualization
image:
  feature: 2016-11-25-Pythagoras-tree-js-feature.png
  topPosition: -50px
bgContrast: dark
bgGradientOpacity: lighter
syntaxHighlighter: yes
---
I have found Pythagorean trees curious ever since I saw a picture of a symmetric regular tree framed on my maths class wall in high school. It seemed like a nice small challenge to write a code that can generate one. I initially did it in R and started from a symmetric case with equal branches at each bifuraction. Then I realized that I can make the tree look more interesting if I add a bias to either side. But the ones that most resemble a real tree are the ones that branch off randomly at each node. 

The transitions in D3 are just so amazing that I had to convert my code to javascript and make the tree morph into yet another random shape at a set interval.

Note to self: Maybe looks better if the trunk were fixed to the ground. Now it's sliding around a little. Now it's scaled to always fit into 512x512 box and keep the aspect ratio

<div align="center">
  <svg width="512" height = "512"></svg>
</div>

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3/4.4.0/d3.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jstat/1.5.3/jstat.min.js"></script>
<script type="text/javascript">

//This program generates a Pythagoras tree with a randomly varying 
//branching ratio at each bifurcation point

function rotationMatrix2D(rad) {
  return [[  Math.cos(rad),   Math.sin(rad)],
          [ -Math.sin(rad),   Math.cos(rad)]];
}


function generatePythagorasTree(maxLevel, p, random_p, k){
  
  function generateTreeRec(level, anchor, angle, base, side, p){
    // baseCube = matrix(c(0,0,1,1,0,1,1,0), 4, 2) * base
    var baseCube = [[0,    0   ],
                    [0,    base],
                    [base, base],
                    [base, 0   ]];

    var R = rotationMatrix2D(angle);

    //Rotate the cube (matrix multiplication R %*% baseCube)
    var rotatedCube = [baseCube.map(row => row[0]*R[0][0] + row[1]*R[0][1]),
                       baseCube.map(row => row[0]*R[1][0] + row[1]*R[1][1])];
    
    var newCube = [ rotatedCube[0].map(x => x + anchor[0]),
                    rotatedCube[1].map(y => y + anchor[1])];
       
    if(level == maxLevel){
      return [{cube: newCube, level: level}];
    }else{
      if(random_p) {
        var p2 = jStat.beta.sample( k * p, k * (1-p) );
      } else{
        var p2 = p
      }
      var angle_left = Math.asin( Math.sqrt(1 - p2) );
      var angle_right = Math.asin( Math.sqrt(p2) );
      var base_left = base * Math.sqrt(p2);
      var base_right = base * Math.sqrt(1 - p2);
      
      return [{cube: newCube, level: level}]
        .concat(generateTreeRec(level + 1, 
                [newCube[0][1 + side], newCube[1][1 + side]], 
                angle + (side === 0 ? -angle_left : Math.PI/2.0 - angle_left), 
                base_left, 
                0, 
                p))
        .concat(generateTreeRec(level + 1, 
                [newCube[0][2 + side], newCube[1][2 + side]], 
                angle + (side === 0 ? -(Math.PI/2.0 - angle_right) : angle_right), 
                base_right, 
                1, 
                p));
                                    
    } 

  }  

  return generateTreeRec(level=0, anchor=[0,0], angle=0, base=1, side=0, p=p);
}

function redraw(){
	var cubes = generatePythagorasTree(maxLevel = nlevels, p=p, random_p = true, k=k);
  cubes.sort(function(a, b) {return a.level - b.level});

  var svg = d3.select('svg');
  var items = svg.selectAll('polygon').data(cubes);
  items.enter().append('polygon').call(setEmAll);
  items.exit().remove();
  items.transition().duration(1500).ease(d3.easeBackInOut).call(setEmAll);
}

function setEmAll(polygons){
  var cubes = d3.selectAll('polygon').data();

  var min_x = d3.min(cubes.map(cbs => d3.min(cbs.cube[0])));
  var max_x = d3.max(cubes.map(cbs => d3.max(cbs.cube[0])));

  var min_y = d3.min(cubes.map(cbs => d3.min(cbs.cube[1])));
  var max_y = d3.max(cubes.map(cbs => d3.max(cbs.cube[1])));

  var x_extent = max_x - min_x;
  var y_extent = max_y - min_y;

	var ratio = x_extent/y_extent;
  
  if(ratio > 1.0){
  	//x is bigger
		var xScale = d3.scaleLinear().domain([min_x, max_x]).range([0, 512]);
  	var yScale = d3.scaleLinear().domain([min_y, max_y]).range([512, 512 - 512/ratio]);
  }else{
  	//y is bigger
		var xScale = d3.scaleLinear().domain([min_x, max_x]).range([512/2.0 * (1 - ratio), 512/2.0 * (1 + ratio)]);
  	var yScale = d3.scaleLinear().domain([min_y, max_y]).range([512, 0]);
  }

  polygons
      .attr("points", function(d){
      var x = d.cube[0]
      var y = d.cube[1]

      return xScale(x[0]) + "," + yScale(y[0]) + " " +
             xScale(x[1]) + "," + yScale(y[1]) + " " +
             xScale(x[2]) + "," + yScale(y[2]) + " " +
             xScale(x[3]) + "," + yScale(y[3]);
      
    })
    .style("fill", "green")
    .style("opacity", 0.5);
    // .style("stroke", "black")
    // .style("stroke-width", 1)
    
}


  // var p       = document.getElementById("pRange").value / 100.0;
  // var k       = document.getElementById("kRange").value * 10;
  // var nlevels = document.getElementById("nlevels").value;
  // console.log(p);

// function run(){
	// if(isRunning){
	// 	document.getElementById("btn").value = "Run";
	// }else{
	// 	document.getElementById("btn").value = "Stop";
		var p = 0.5;
	  var k = 20;
	  var nlevels = 9;
		setInterval(redraw, 1500);
	// }
	// isRunning = !isRunning
// }
  
var isRunning = false;

</script>

{% highlight js %}
function rotationMatrix2D(rad) {
  return [[  Math.cos(rad),   Math.sin(rad)],
          [ -Math.sin(rad),   Math.cos(rad)]];
}


function generatePythagorasTree(maxLevel, p, random_p, k){
  
  function generateTreeRec(level, anchor, angle, base, side, p){
    // baseCube = matrix(c(0,0,1,1,0,1,1,0), 4, 2) * base
    var baseCube = [[0,    0   ],
                    [0,    base],
                    [base, base],
                    [base, 0   ]];

    var R = rotationMatrix2D(angle);

    //Rotate the cube (matrix multiplication R %*% baseCube)
    var rotatedCube = [baseCube.map(row => row[0]*R[0][0] + row[1]*R[0][1]),
                       baseCube.map(row => row[0]*R[1][0] + row[1]*R[1][1])];
    
    var newCube = [ rotatedCube[0].map(x => x + anchor[0]),
                    rotatedCube[1].map(y => y + anchor[1])];
       
    if(level == maxLevel){
      return [{cube: newCube, level: level}];
    }else{
      if(random_p) {
        var p2 = jStat.beta.sample( k * p, k * (1-p) );
      } else{
        var p2 = p
      }
      var angle_left = Math.asin( Math.sqrt(1 - p2) );
      var angle_right = Math.asin( Math.sqrt(p2) );
      var base_left = base * Math.sqrt(p2);
      var base_right = base * Math.sqrt(1 - p2);
      
      return [{cube: newCube, level: level}]
        .concat(generateTreeRec(level + 1, 
                [newCube[0][1 + side], newCube[1][1 + side]], 
                angle + (side === 0 ? -angle_left : Math.PI/2.0 - angle_left), 
                base_left, 
                0, 
                p))
        .concat(generateTreeRec(level + 1, 
                [newCube[0][2 + side], newCube[1][2 + side]], 
                angle + (side === 0 ? -(Math.PI/2.0 - angle_right) : angle_right), 
                base_right, 
                1, 
                p));
                                    
    } 

  }  

  return generateTreeRec(level=0, anchor=[0,0], angle=0, base=1, side=0, p=p);
}

function redraw(){
  var cubes = generatePythagorasTree(maxLevel = nlevels, p=p, random_p = true, k=k);
  cubes.sort(function(a, b) {return a.level - b.level});

  var svg = d3.select('svg');
  var items = svg.selectAll('polygon').data(cubes);
  items.enter().append('polygon').call(setEmAll);
  items.exit().remove();
  items.transition().duration(1500).ease(d3.easeBackInOut).call(setEmAll);
}

function setEmAll(polygons){
  var cubes = d3.selectAll('polygon').data();

  var min_x = d3.min(cubes.map(cbs => d3.min(cbs.cube[0])));
  var max_x = d3.max(cubes.map(cbs => d3.max(cbs.cube[0])));

  var min_y = d3.min(cubes.map(cbs => d3.min(cbs.cube[1])));
  var max_y = d3.max(cubes.map(cbs => d3.max(cbs.cube[1])));

  var x_extent = max_x - min_x;
  var y_extent = max_y - min_y;

  var ratio = x_extent/y_extent;
  
  if(ratio > 1.0){
    //x is bigger
    var xScale = d3.scaleLinear().domain([min_x, max_x]).range([0, 512]);
    var yScale = d3.scaleLinear().domain([min_y, max_y]).range([512, 512 - 512/ratio]);
  }else{
    //y is bigger
    var xScale = d3.scaleLinear().domain([min_x, max_x]).range([512/2.0 * (1 - ratio), 512/2.0 * (1 + ratio)]);
    var yScale = d3.scaleLinear().domain([min_y, max_y]).range([512, 0]);
  }

  polygons
      .attr("points", function(d){
      var x = d.cube[0]
      var y = d.cube[1]

      return xScale(x[0]) + "," + yScale(y[0]) + " " +
             xScale(x[1]) + "," + yScale(y[1]) + " " +
             xScale(x[2]) + "," + yScale(y[2]) + " " +
             xScale(x[3]) + "," + yScale(y[3]);
      
    })
    .style("fill", "green")
    .style("opacity", 0.5);
    // .style("stroke", "black")
    // .style("stroke-width", 1)
    
}


  // var p       = document.getElementById("pRange").value / 100.0;
  // var k       = document.getElementById("kRange").value * 10;
  // var nlevels = document.getElementById("nlevels").value;
  // console.log(p);

// function run(){
  // if(isRunning){
  //  document.getElementById("btn").value = "Run";
  // }else{
  //  document.getElementById("btn").value = "Stop";
    var p = 0.5;
    var k = 50;
    var nlevels = 10;
    setInterval(redraw, 1500);
  // }
  // isRunning = !isRunning
// }
  
var isRunning = false;
{% endhighlight %}