import sys,time
sys.argv[3] = int(sys.argv[3])
sys.argv[4] = int(sys.argv[4])
print(sys.argv)
print([type(x) for x in sys.argv])
if len(sys.argv) != 5 or type(sys.argv[1]) != str or type(sys.argv[2]) != str or sys.argv[4] < 1: exit(f"incorrect args: {sys.argv} {[type(x) for x in sys.argv]}, expected 3 args with first being a {str}")
si = sys.argv[3]
di = sys.argv[4]
with open(sys.argv[1]) as f:
    source = f.readlines()

with open(sys.argv[2]) as f:
    dest = f.readlines()
print((len(source[si]),len(dest[di])))
if len(dest[di-1]) < 33: print(dest[di-1])
else: print(dest[di-1][:33])
s_start = source[si][0:9]
d_start = dest[di][0:9]
print(d_start)
if s_start != d_start: exit(f"source {s_start}... doesn't match {d_start}...'")
time.sleep(2)
dest[di] = source[si]
with open(sys.argv[2], "w") as f:
    f.writelines(dest)
