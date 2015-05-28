Program solves Rubik's cube NxNxN
---
Program is writen using http://www.sagemath.org/

This method is generalization of http://www.gap-system.org/Doc/Examples/rubik.html

For more info, please see: http://en.wikipedia.org/wiki/Rubik%27s_Cube_group

For dimension 2x2x2 where is function which solves it by 
naitive graphs algorithm (meet it the middle)

---
Sample of working (calculation of Gog's Number for 2x2x2):
```
sage problem_5_15.sage 
        +-------+                
        |  1  2 |
        |  3  4 |
+-------+-------+-------+-------+
|  5  6 |  8  9 | 11 12 | 15 16 |
|  7 -1 | -1 10 | 13 14 | 17 18 |
+-------+-------+-------+-------+
        | -1 19 |
        | 20 21 |
        +-------+                
Generators of Group =
[   '(1,12,21,7)(2,14,20,5)(16,15,17,18)',
    '(4,15,21,10)(2,17,19,9)(11,12,14,13)',
    '(11,15,5,8)(12,16,6,9)(4,2,1,3)']
Cube.order() =  2^4 * 3^8 * 5 * 7  =  3674160
random item =  (1,18,4,15)(2,16,20,9)(3,6,8)(5,7,11,12)(10,13,19)
        +-------+                
        | 18 16 |
        |  6 15 |
+-------+-------+-------+-------+
|  7  8 |  3  2 | 12  5 |  1 20 |
| 11 -1 | -1 13 | 19 14 | 17  4 |
+-------+-------+-------+-------+
        | -1 10 |
        |  9 21 |
        +-------+                
orbits =  [[1, 3, 12, 4, 14, 16, 21, 15, 2, 13, 20, 6, 10, 7, 5, 17, 11, 9, 8, 19, 18]]
BFS 100% completed.
God's number =  11  
```
