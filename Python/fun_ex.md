# #ex1
def loby(b,a,c,d):
    if type(b) != str and b ==d:
        print("this condition is true")
    elif b >=a or b <= c:
        print('this condition is accurate')
    else:
        print ('False')

loby(102,2,45,102)

# ex2
def loby(b,a,c,d=10):
    if b != str and b ==d:
        print("this condition is true")
    else:
        print ('False')

loby("ken",2,45)

#ex3
def _list(a,b):
    a=[1,2,3]
    b=['ken','sam','nic']

    for lis in _list:
        print(lis)

_list= a,b

#ex4

def loop(items):
    for v in items:
        if v >= 10:
            return
        else:
            print("stop")

loop([1,2,3,4,5,15])

#ex5

def create_new_tag(t_name: str, t_value: str) -> str:
    print(type(t_name))
    return t_name

demo = create_new_tag(1, 2)
print(demo)
