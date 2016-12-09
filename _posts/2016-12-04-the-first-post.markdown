---
layout: post
title: "The Very First Post"
date:   2016-12-04 01:01:00
last_modified_at:
excerpt: "Welcome to my first post"
categories: thoughts
tags:  ["thoughts"]
image:
  feature: 2016-12-04-the-first-post-feature.jpg
  topPosition: -50px
bgContrast: dark
bgGradientOpacity: lighter
syntaxHighlighter: no
---

## The very first post

Hello world! 

Welcome to my first post.

I have had thoughts about starting my own blog for a while now. 
I guess on the one hand it is trendy these days to have your own tech and what not blog, but on the other it's useful to have representation of myself available online that showcases some of my work as a kind of portfolio and serves as a medium for self-expression.
Finally, maybe someone might some day find some of it actually useful or relevant to whatever they are doing.

It took me a couple of weeks worth of evenings to get this site up and running.
Most of the time, to be honest, was spent choosing a decent theme and tweaking the styling.
Talking about stylesheets, I have some experience from about 7 years ago of developing HTML, CSS and Javascript. 
But man, have things changed in the mean time.
I thought setting up my own blog would be a piece of cake, and it was, but a very large and chewy one. 
Mostly enjoyable though.

- First of all I chose *Jekyll* as my blog engine. It involved learning the special folder structure, config files, *yaml* headers and *liquid* syntax
- Secondly, it was picking a theme that took way longer than I thought it would. 
I tried out several and each of them had some specific peculiarities. 
I finally settled with the one called [Mickey](https://github.com/vincentchan/mickey) which has a beautiful minimalistic reactive design with a nice clean code.
- For styling I had to familiarize myself with *sass* which is a *css* preprosessor
- Setting up github pages which was not that new to me. I wasn't aware that github actually does the markdown rendering for myself, so I just upload the source code instead of the generated *_site* folder
- Getting the pipeline from Rmarkdown to markdown working involved figuring out the R package `servr` and a function therein called `servr::jekyll()` which conveniently watches your R files for changes and rebuilds the markdown upon changes. It actually worked pretty much out of the box, I just had to customize the folder structure where the generated images are put and had to write a script that changes markdown image tags into `html divs` with proper class information. This way the images fit the style of the rest of the blog.

All in all an enjoyable journey and I feel I have learned a great deal about the modern web technologies.

Oh, and the person on the cover photo for this post is myself overlooking a bay just in front of the Okinawa Institute of Science and Technology, where I'm currently in the process of obtaining a PhD degree. And yes, I took this photo myself.

