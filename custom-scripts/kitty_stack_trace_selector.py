
# matches python tracebacks and rust backtraces

s = """
Hello, world!
thread 'main' panicked at 'called `Option::unwrap()` on a `None` value', src/main.rs:3:7
stack backtrace:
   0: rust_begin_unwind
             at /rustc/90c541806f23a127002de5b4038be731ba1458ca/library/std/src/panicking.rs:578:5
   1: core::panicking::panic_fmt
             at /rustc/90c541806f23a127002de5b4038be731ba1458ca/library/core/src/panicking.rs:67:14
   2: core::panicking::panic
             at /rustc/90c541806f23a127002de5b4038be731ba1458ca/library/core/src/panicking.rs:117:5
   3: core::option::Option<T>::unwrap
             at /rustc/90c541806f23a127002de5b4038be731ba1458ca/library/core/src/option.rs:950:21
   4: backtrace_test::foo
             at ./src/main.rs:3:5
   5: backtrace_test::bar
             at ./src/main.rs:7:5
   6: backtrace_test::main
             at ./src/main.rs:12:5
   7: core::ops::function::FnOnce::call_once
             at /rustc/90c541806f23a127002de5b4038be731ba1458ca/library/core/src/ops/function.rs:250:5
note: Some details are omitted, run with `RUST_BACKTRACE=full` for a verbose backtrace.
"""

s = s.split('\n')

s
import re


re.match('  File "([^"]+)", line (\d+),', s[2]).groups()

import re
python_line = '  File "/Users/conraddean/.dotfiles/what.py", line 8, in bar'
re.match('  File "([^"]+)", line (\d+),', python_line).groups()


FILE_EXTENSION = '\.(?:[a-zA-Z0-9]{2,7}|[ahcmo])(?:\\\b|[^.:])'
path_regex = '(?:\S*?/[\\\r\S]+)|(?:\S[\\\r\S]*%s)\\\b' % FILE_EXTENSION
linenum = '.+(?P<path>%s):(?P<line>\d+):?.*' % path_regex

FILE_EXTENSION = '\.(?:[a-zA-Z0-9]{2,7}|[ahcmo])(?:\\\b|[^.:])'
path_regex = '(?:\S*?/[\\\r\S]+)|(?:\S[\\\r\S])\\\b'


linenum = '.+(?P<path>%s):(?P<line>\d+):?.*' % path_regex

file_ext = r'\.(?:[a-zA-Z0-9]{2,7}|[ahcmo])(?:\b|[^.])'
path = r'(?:\S*?/[\r\S]+)|(?:\S[\r\S]*%s)\b' % file_ext
finder = r' ?(?: *[^ ]*) ?(?P<path>%s):(?P<line>\d+)' % path

finder = r".*\b(\S+/\S+):(\d+):\d+"

lines = [
    '  File "/Users/conraddean/.dotfiles/what.py", line 8, in bar',
    "thread 'main' panicked at 'called `Option::unwrap()` on a `None` value', src/main.rs:3:7",
    "             at ./src/main.rs:3:5"
]

line = "thread 'main' panicked at 'called `Option::unwrap()` on a `None` value', src/main.rs:3:7"

line = "             at ./src/main.rs:3:5"
finder = r'(?:"|\'|\s)(.+:\d+:\d+)'

for line in lines:
    try:
        re.match(finder, line).groups()
    except:
        print(f"broke on '{line}'")

re.match(finder, "goat.rs:22:800").groups()
re.match(finder, "one/two/three/goat.rs:22:800").groups()
re.match(finder, "/one/two/three/goat.rs:22:800").groups()
re.match(finder, "at /one/two/three/goat.rs:22:800").groups()





import re

FILE_EXTENSION = r"\.(?:[a-zA-Z0-9]{2,7}|[ahcmo])(?:\b|[^.])"
path_regex = r"(?:\S*?/[\r\S]+)|(?:\S[\r\S]*%s)\b" % FILE_EXTENSION
default_linenum_regex = r"(?P<path>%s):(?P<line>\d+)" % path_regex

line = "             at ./src/main.rs:3:5"
re.search(default_linenum_regex, line).groupdict()



import re
python_line = '  File "/Users/conraddean/.dotfiles/what.py", line 8, in bar'
re.search('File "(?P<path>[^"]+)", line (?P<line>\d+),', python_line).groups()

re.search('File "(?P<path>[^"]+)", line (?P<line>\d+),', python_line).groupdict()






rust_stack = """
thread 'main' panicked at 'called `Option::unwrap()` on a `None` value', src/main.rs:3:7
stack backtrace:
   0: rust_begin_unwind
             at /rustc/90c541806f23a127002de5b4038be731ba1458ca/library/std/src/panicking.rs:578:5
   1: core::panicking::panic_fmt
             at /rustc/90c541806f23a127002de5b4038be731ba1458ca/library/core/src/panicking.rs:67:14
   2: core::panicking::panic
             at /rustc/90c541806f23a127002de5b4038be731ba1458ca/library/core/src/panicking.rs:117:5
   3: core::option::Option<T>::unwrap
             at /rustc/90c541806f23a127002de5b4038be731ba1458ca/library/core/src/option.rs:950:21
   4: backtrace_test::foo
             at ./src/main.rs:3:5
   5: backtrace_test::bar
             at ./src/main.rs:7:5
   6: backtrace_test::main
             at ./src/main.rs:12:5
   7: core::ops::function::FnOnce::call_once
             at /rustc/90c541806f23a127002de5b4038be731ba1458ca/library/core/src/ops/function.rs:250:5
note: Some details are omitted, run with `RUST_BACKTRACE=full` for a verbose backtrace.
""".split("\n")

python_stack = """
Traceback (most recent call last):
  File "/Users/conraddean/.dotfiles/what.py", line 10, in <module>
    bar()
  File "/Users/conraddean/.dotfiles/what.py", line 8, in bar
    return goat()
           ^^^^^^
  File "/Users/conraddean/.dotfiles/what.py", line 5, in goat
    return foo()
           ^^^^^
  File "/Users/conraddean/.dotfiles/what.py", line 2, in foo
    raise Exception("boop")
Exception: boop""".split("\n")

rust_line = rust_stack[12]
python_line = python_stack[7]

import re

python_traceback = 'File "(?P<path>[^"]+)", line (?P<line>\d+),'

FILE_EXTENSION = r"\.(?:[a-zA-Z0-9]{2,7}|[ahcmo])(?:\b|[^.])"
path_regex = r"(?:\S*?/[\r\S]+)|(?:\S[\r\S]*%s)\b" % FILE_EXTENSION
default_linenum_regex = r"(?P<path>%s):(?P<line>\d+)" % path_regex

re.search(python_traceback, python_line).groupdict()
# {'path': '/Users/conraddean/.dotfiles/what.py', 'line': '5'}

re.search(default_linenum_regex, rust_line).groupdict()
# {'path': './src/main.rs:3', 'line': '5'}
