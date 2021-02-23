import os
from tabulate import tabulate

file_original_name = "original.txt"
file_change_name = "change.txt"

file_original = os.path.join(os.path.dirname(os.path.realpath(__file__)), file_original_name)
file_change = os.path.join(os.path.dirname(os.path.realpath(__file__)), file_change_name)

with open(file_original, "r") as f:
    original = [ line.rstrip("\n") for line in f.readlines()]
with open(file_change, "r") as f:
    change = [ line.rstrip("\n") for line in f.readlines()]

transformed_original = [ name.rsplit(" ", 1) for name in original ]
transformed_change = [ name.rsplit(" ", 1) for name in change ]

lastname_dup = {}
for name_ori in transformed_original:
    for name_cha in transformed_change:
        if name_ori[0] == name_cha[0]:
            lastname_dup[" ".join(name_ori)] = " ".join(name_cha)

result = []
for item in lastname_dup.items():
    name_ori = item[0].rsplit(" ", 1)[1]
    name_cha = item[1].rsplit(" ", 1)[1]
    name_length = len(name_ori) if len(name_ori) < len(name_cha) else len(name_cha)
    counter = 0
    for a, b in zip(name_ori, name_cha):
        if a == b:
            counter += 1
    if counter/name_length >= 0.5:
        result.append([item[0], item[1]])

for item in result:
    if item[0] in original:
        original.remove(item[0])
    if item[1] in change:
        change.remove(item[1])

result.append(["\n".join(original), "\n".join(change)])

print(tabulate(result, headers=["Original", "Change"], tablefmt="grid"))