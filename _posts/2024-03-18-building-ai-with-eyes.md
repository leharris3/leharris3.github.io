---
layout: post
title: Building AI With Eyes
date: 2024-03-18
description:
tags:
categories:
---

On a long car ride home from Chapel Hill, I listened to a fantastic [interview](https://www.youtube.com/watch?v=5t1vTLU7s40&ab_channel=LexFridman) between Yan Lecunn and Lex Fridman. The two discussed, among many other things, the fundamental limitations of Large Language Models (LLMs). Yan mentioned that for a an entity to exhibit intelligence it must display at a minimum :

1. Persistent memory.
2. A capacity to understand the physical world.
3. The ability to reason.
4. The ability to plan.

LLMs, in their current state, display none of these qualities. I believe, as does Yan, that natural language is just too crude of an approximation of the natural world to build a complete world model. LLMs need the ability to see and hear as well. This is one of the core ideas behind Computer Vision (CV): understanding the world through sight. And so, this brings us to a primary goal of AI. We seek to build systems that can solve complicated tasks in the real world across a variety of domains. The precursor to this challenge is developing robust world models that AI can easily generalize from.

LLMs represent the best world models constructed to date. SOTA LLMs can generalize to basically any task which requires use of natural language. For example, writing poems, solving coding problems, basic mathematics, and so on. These models, however, lack a robust understanding of the real world. This fact has much to do with the way these models distill a world model (i.e., their pre-training). LLMs are pre-trained on next-token prediction using a large text corpus. This paradigm is made especially convenient by the fact that words (unlike images) are discrete units of information. 

So now, Yan asks the obvious question: how do you pre-train large models on continuous data types like images? The motivation here of course is to create a model with a general understanding of the physical world, not just language. The answer turns out to be somewhat tricky. The naive approach of course is to predict the next frame in videos. This strategy doesn't work for a number of reasons. This roadblock has something to do with the continuous nature of video and the presence of a number of latent variables. Simply put, self-supervised methods are ineffective.

What about supervised methods? Let's pre-train a huge vision model using image classification. This also turns out to be tricky. Another naive idea is to train a classifier using a bunch of images and their augmented counter parts. But this doesn't work either. The secret sauce it turns out is *contrastive learning.* An image and an augmented version of it (e.g., a masked, distorted variation, etc.) are encoded together as a joint embedding. This vector is used the predict an object class. Do this enough times and you've built a very powerful, general purpose vision backbone. Why does this work? At a high level it seems important to teach a model both relevant *and* irrelevant features of an image simultaneously. In NLP during the pre-training stage LLMs learn both likely *and* unlikely continuations. We simply extent this idea to images.

FAIR at Meta have developed a number of techniques that leverage this approach. Mainly, [V-JEPA](https://ai.meta.com/blog/v-jepa-yann-lecun-ai-model-video-joint-embedding-predictive-architecture/) and [DINO](https://ai.meta.com/blog/dino-v2-computer-vision-self-supervised-learning/). It is important to note that building a unified language-vision backbone is only step 2 (*a capacity to understand the physical world*) along the path to AGI. Developing models with persistent memory and legitimate reasoning abilities remain outstanding challenges. I similarly agree with Yan that machine intelligence will scale linearly with time. The path to smarter than human, general purpose AI will span a long and challenging road. Still, I am greatly excited that the fine folks at Meta are sharing their work publicly. The ideas are simple, but the approaches that will lead us to AGI remain unclear. It looks like AI researcher have their work cut out for them.