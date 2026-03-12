---
layout: post
title: "(4/N) ML Concepts – Computational Graphs"
date: 2026-03-08
description: "Visualizing the forward and backward pass of a neural network."
tags:
categories:
---

### Building up a Computational Graph

*This week, we draw inspiration from pages 200-206 of "Deep Learning" (Goodfellow et al. 2016). This (in my super duper humble opinion) is **the** definitive treatment of deep neural networks and essential related concepts. Readers interested in building deeper intuition of the capabilities and limitations of neural networks–as well as the governing mathematics of deep learning–will benefit enormously from a review of this classic treatment.*

--- 

This week, we're venturing to go where most researchers never want to go: *backwards*. To develop a deep intuition for back-propagation and of neural networks in general, we'll first introduce the central concept of a **computational graph**. This abstraction is incredibly useful when thinking about deep learning for a number of reasons. First, a computational graph has a flexible topology, meaning one can be designed to represent virtually any kind of statistical model in existantce. Second, these devices help us to visualize the **forward propagation** and **back-propagation** algorithms as they work throughout a model.

Consider first a single **node** $$u^{(i)}$$ living in a computational graph $$ \mathcal{G} = \{ (V, E) \}$$, where $$V$$ denotes the **value** and $$E = \{ (V^{(i)}, V^{(j)}) \}$$ the set of **edges** belonging to a node, where edges run from $$ V^{(i)} \rightarrow V^{(j)}$$. By definition, every node in our graph is either associated with a real-valued entity called a *value*, or with an **opperation** that maps *value-nodes* to value-nodes . Values can be **scalars**, **vectors**, **matricies**, or **tensors**, but for conceptual purposes all values can be thought of (and indeed are equivalent to) *vectors*. Let's assign our node a scalar value $$u^{(i)} = 1.36 $$, plop it into a graph $$\mathcal{G}$$, and visualize the result below.

<div style="display: flex; justify-content: center; gap: 10px;">
  <img src="/assets/img/ml-concepts/backprop/cg_single_node.png" height="200"/>
</div>

A computational graph containing just a single neuron is pretty boring! Let's define a new, *opperation-node* $$f(x) = 2x$$ and calculate $$u^{(j)} = f(u^{(i)})$$. (Value-nodes are denoted by black-on white circles, opperation nodes by black-on-white squares).

<div style="display: flex; justify-content: center; gap: 10px;">
  <img src="/assets/img/ml-concepts/backprop/cg_op_node.png" height="200"/>
</div>

Above is a simple example of a forward pass through a model. On the left-hand side, the node $$u^{(i)}$$ serves as the sole *input* to a model, and on the right-hand side $$u^{(j)}$$ is the sole *output* neuron. A key realization is that all neural networks may be represented as a *directed acyclic graph* (DAG) like the one above. *Directed*, meaning each edge points from exactly one node to the other, and *acyclic*, meaning our graph contains no cycles. Information flows through the net in a sequence fashion, where neurons whose values are dependent upon other nodes (e.g., the value of $$u^{(j)}$$ *depends* upon the value of $$u^{(i)}$$), are **child nodes**; values of **parent nodes** such as $$u^{(i)}$$ are computed earlier during forward propagation.

Let $$\mathbb{A}^{(i)}$$ be the set of all parent nodes with an edge pointing toward a node $$u^{(i)}$$. We write the value of $$u^{(i)}$$ as

$$
\begin{equation} \tag{1}
   f^{(i)} ( \mathbb{A}^{(i)} )
\end{equation}
$$

- back-propagation

### References

- [1] Bishop, C. M. (1995). The multi-layer perceptron. In *Neural networks for pattern recognition* (Chapter 4, pp. 116–163). Oxford University Press.