vim-sandwich
============

The set of operator and textobject plugins to search/select/edit sandwiched textobjects.

# Quick start

*sandwich.vim* is the set of operator and textobject plugins to
add/delete/replace surroundings of a sandwiched textobject, like `(foo)`, `"bar"`.

###add
Press sa*{motion/textobject}{addition}*.
For example, a key sequence *saiw(* makes `foo` to `(foo)`.

###delete
Press sdb or sd*{deletion}*.
For example, key sequences *sdb* or *sd(* makes `(foo)` to `foo`.
sdb searchs a set of surrounding automatically.

###replace
Press srb*{addition}* or sr*{deletion}{addition}*.
For example, key sequences *srb"* or *sr("* makes `(foo)` to `"foo"`.

![sandwich.vim](http://art49.photozou.jp/pub/986/3080986/photo/223169354_org.v1432363500.gif)

That's all. Now you already know enough about sandwich.vim.

# Slightly more...

This plugin serves functions to add/delete/replace surroundings of sandwiched texts. These functions are implemented genuinely by utilizing operator/textobject framework. Thus their action can be repeated by `.` command without any dependency. It consists of two parts, *operator-sandwich* and *textobj-sandwich*.

###operator-sandwich

* Add surroundings: mapped to the key sequence *sa*
* Delete surroundings: mapped to the key sequence *sd*
* Replace surroundings: mapped to the key sequence *sr*

###textobj-sandwich

* Search and select a sandwiched text automatically: mapped to the key sequence *ib* and *ab*
* Search and select a sandwiched text with query: mapped to the key sequence *is* and *as*

They have highlighting feature, count acceptance, and many beneficial options! Try them!

