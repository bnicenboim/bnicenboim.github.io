---
title: "Next Word Showdown"
format:
  html:
    toc: false
    navbar: false
    page-layout: article
    theme:
      - cosmo
      - brand
    css: word-prediction-explained.css
    include-in-header:
      text: |
        <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='%23667eea'/><stop offset='1' stop-color='%23764ba2'/></linearGradient></defs><rect width='100' height='100' rx='20' fill='url(%23g)'/><text x='50' y='68' font-size='62' text-anchor='middle' font-family='system-ui,sans-serif'>💬</text><text x='68' y='52' font-size='28' text-anchor='middle' font-family='system-ui,sans-serif' font-weight='bold' fill='white'>?</text></svg>">
---

**[Play the game](word-prediction.html)**

## What the game is about

You see the beginning of a sentence and try to guess the next hidden word before anyone else does. That's it. But here's the thing: **predicting the next word is something your brain does automatically, all the time, without you noticing.**

---

## Your brain is always one step ahead

Try finishing this:

> <em>She put on her coat, picked up her keys, and walked out the ___.</em>

You almost certainly thought about _door_. Something in your brain just... knew.

Now this one:

> <em>The scientist published her results in a peer-reviewed ___.</em>

_Journal_, probably. Or maybe _paper_.

> <em>He ordered a coffee and a chocolate ___.</em>

_Cake? Croissant? Cookie?_ Harder. Several words fit equally well.

That difference matters: **some words are much easier to predict than others.** Predictable words feel almost inevitable. Unpredictable ones could go in many directions. The game makes this visible. Some words get guessed on the first try, others stump everyone.

---

## How do we know the brain predicts?

You can't _feel_ your brain making predictions. But scientists have found ways to catch it in the act.

One way is tracking people's eyes while they read. Your eyes don't slide smoothly across a page. They jump from word to word. And it turns out they spend less time on predictable words, sometimes skipping them entirely, while lingering on surprising ones. The brain already has a good guess for predictable words, so it doesn't need to look as carefully.

There's also a more direct approach. Your brain runs on electricity: billions of cells communicating through small bursts of electrical activity, these are your neurons. All those tiny signals add up, and some of that activity actually reaches the surface of your head. By placing small sensors on someone's scalp (a technique called EEG, for electroencephalography), you can pick up those signals while the person reads. It looks like a cap covered in wires, and what it records is a kind of summary of what millions of neurons are doing at each moment. When a word shows up that the reader didn't expect, the electrical response shifts. The more surprising the word, the bigger the shift. The brain is, in a sense, going: "Hang on, that's not what I had in mind."

---

## Context is everything

Watch what happens when you add more context:

> <em>He ordered a coffee and a chocolate ___.</em>

Still hard. But:

> <em>He was celebrating his birthday. He ordered a coffee and a chocolate ___.</em>

Now _cake_ is much more obvious.

Guesses become easier the further into a sentence you get. Your brain pulls in everything available: the words already said, what makes sense in the real world, what people typically say in that kind of situation. More context means fewer plausible options, and easier guesses.

The same thing happens when you listen. You start processing what someone is saying before they've finished the sentence. In conversation, people often begin composing their reply _while the other person is still speaking_, because they can already tell where it's going.

---

## So what are the AI players doing?

In the game, the AI players do the same thing you do: they look at the words revealed so far and return their best guess.

The AI players in this game are **large language models**: programs trained by reading enormous amounts of text, including books, news articles, websites, and conversations.

The training works like this: the model sees a sequence of words and tries to guess what comes next. When it's wrong, it adjusts a little. After billions of rounds, it develops something like an intuition for how language flows, which words tend to follow which, in what contexts. This next-word prediction task is actually the foundation of chatbots like ChatGPT too. Before a chatbot can hold a conversation or answer your questions, it first has to learn the patterns of language by practicing exactly this: predicting the next word, over and over, on enormous amounts of text.

What makes a language model bigger or smaller comes down to **parameters**: numbers inside the model that get adjusted during training. Think of them as tiny knobs. Each knob controls a small part of how the model responds to a word or a pattern. More knobs means finer distinctions and subtler patterns. Fewer knobs means a rougher, blurrier picture of the language.

The models in this game are small and old by today's standards. The English model (Pythia, from 2023) has about 410 million parameters. The Dutch and Spanish ones are based on GPT-2 (from 2019) and have about 125 million parameters each. That sounds like a lot until you hear that ChatGPT's most powerful models are estimated at around 1.8 _trillion_ parameters, roughly 4,000 times more than Pythia. A bit like comparing a bicycle to a jumbo jet.

So why not use the big ones? Because the models in this game have to run _locally_, right here in your browser, on your own computer. ChatGPT runs on massive servers, warehouses full of specialized hardware operated by companies like OpenAI. The models here are tiny enough to download and run on a normal laptop, or even a phone.

The English model, being larger, tends to predict a bit better. But the smaller Dutch and Spanish models were trained on text in their own languages, so they do much better when the sentence matches, just as you'd expect.

---

## Birds and planes

Are human minds and language models the same thing? Definitely not. They are as different as birds and airplanes. One is alive and evolved over millions of years; the other is engineered metal. They also have very different motivations for flying. But they both fly, and they both succeed because they exploit the same physics: aerodynamics, the way air flows around a wing.

Studying airplanes can teach us a lot about the _medium_ birds fly through. Not about feathers or muscles, but about air itself, what makes flight possible in the first place.

Something similar is going on with language models and human minds. They're built completely differently, but they both navigate the same thing: **language**. By studying what a model finds predictable or surprising, we learn about regularities in the language: what tends to appear where, what's common, what's unusual. Those are the same regularities that shape how our brains process words. In a way, the game score measures this too: high scores go to whoever best matches the statistical patterns of the language.

How far this analogy stretches is genuinely controversial. Some researchers argue that language models are so different from brains that comparing them is misleading. Others think the similarities go deeper than we'd expect. Nobody has settled this, and figuring it out is one of the most interesting open questions in the field right now.

---

Next time you finish someone else's sentence without thinking, remember: your brain has been playing this game your whole life.

---

_[Bruno Nicenboim](https://bruno.nicenboim.me/) — Computational Cognitive Science, Tilburg University_
