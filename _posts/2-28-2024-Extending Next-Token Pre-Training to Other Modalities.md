**Extending Next-Token Pre-Training to Other Modalities**
Inspired By: [This Paper](https://huggingface.co/papers/2402.17139)

I've been thinking this morning about how to generalize the pre-training, fine-tuning scheme that is a winning formula for LLMs to other modalities. Currently, to make very helpful assistants that use natural language we adopt a two-stage approach:

1. Large-scale pre-training on Internet documents
2. Instruction tuning using expert responses and RLHF

There are plenty of other tricks I didn't mention. But will this approach work for other modalities? For example, let's say we trained a conversation agent on trillions of `(audio_n, audio_n+1)` pairs. The rationale (I think) of the paper above is that a pretty good world model is latent in that training set. The same holds for video. By learning to predict the next token in a sequence, a large enough model with sufficient data will begin to build up a surprisingly robust world model.

Let's further motivate this extension to other modalities. Oftentimes when we solicit the advice of experts, our prompts can only be satisfied (or efficiently addressed) using a mixture of modalities. For example, let's say I'm assembling a Lego set. I get stuck so I ask my brother for help. He shouts down the stairs to me "you just need to insert the yellow bit into the long brown piece!" Has my brother answered my question, *sure*. But has he *efficiently* answered my prompt, probably not. What would be nice is if he could *show* me what to do next. I think you see where I'm going with this.

Imagine an assistant that could answer your questions with a mixture of modalities. Just as any good instructional documentation is sure to include text, images, and videos – so to should a virtual assistant be able to *show* me the answers to my prompts. Ideally, this process should be as natural and continuous as any real-life interaction with a human, embodied expert. Now let's say I'm a stay-at-home Mom. I want to bake a cake for my son Timothy's 8th birthday. I open my laptop and place my phone on the counter. I ask the virtual agent: *how can I make a delicious chocolate cake with only the ingredients currently in my kitchen?* My answer is then conditioned on the stream of frames captured by my phone, my natural language prompt, and the entirety of my previous interactions with the agent. In response, I receive a list of detailed instructions including images to elucidate the baking process. At one point I get stuck, *how do I deglaze the pan*, I ask. The agent decides it would be better to show me. A video is generated to guide me along.

Slowly but surely we inching towards something that looks like ***Her***. The only difference is that our agents will be able to respond to questions in *videos* as naturally as in any other modality. Imagine a basketball coach who wants to demonstrate a drill involving some of his athletes. He asks his agent to generate a video of his boys running a play. The boys gather around his laptop and watch a hyper-realistic simulation of a play they never ran featuring their likenesses. Imagine a songwriter asking for inspiration while writing a country pop ballad. While a model could provide lyrics, maybe even musical charts in our current day, it would be more useful for an agent to sing out their suggestion. Keep in mind that the English language is a lossy representation of the natural world. Other modalities are bound to contain latent features relevant to constructing a truly robust world model. 

The gazillion-dollar question then becomes do we have enough data lying around to compress a super-useful entity given *current* methods? The key word of course is *current*. Assuming compute is not a factor, I suspect that a well-coordinated effort to conduct large-scale pre-training of a model on next-token prediction of words, audio, and videos would yield something far beyond our current capabilities. Maybe this has already been done, and maybe there is a good reason it doesn't work. Suffice it to say that the ideas discussed today are in no way intended to be viewed as novel or practical. Today I am just discussing the obvious:



1. The future of AI assistants is expanding to new modalities
2. Features needed to build a complete world model are latent in video and audio
3. Expanding the next-token prediction + instruction tuning training scheme to other modalities may be an effective way of learning these features
