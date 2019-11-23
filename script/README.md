# Atree Demo Scripts

Here are some simple scripts to illustrate using Atree mix tasks.

Usage examples:

    $ script/mix_list
    $ script/mix_export_lv_markdown | vim -
    $ script/mix_export_lv_html > /tmp/lv.html ; gopen /tmp/lv.html

Note that to run the `atree*` examples, you will first have to generate the
`atree` escript:

    $ mix escript.build

After you run this command, you'll find an `atree` executable in your project
directory.
