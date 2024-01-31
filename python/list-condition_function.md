```py
a = 10
b = 10

# if a < b:
#     print("less than value")
# else:
#     print("not less than")

#
if a > b :
    print("a is greater than b")

elif a == b or b != a :
    print("this condition is true")

else:
    print("b is greater number")


lis = [1,2,3,456,65,787,444,66,]
index = lis.index(66)
print("66 index number:",index )
print(lis[5])
lis.append(4)

# lis.clear()
lis.count(3)
lis.extend("2234")
print(type(lis.index('4')))


def ken(lis):
    if 767 in lis:
        return True
    elif 66 in lis:
        if 66 == lis[3]:
            return False
        else: 
            return False
    else:
        return False

list = [767]

print(ken)
```
