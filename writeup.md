# Spimbot Tracer

This is a class project in CS233
## ASCII Art

```bash
  _______                      
 |__   __|                     
    | |_ __ __ _  ___ ___ _ __ 
    | | '__/ _` |/ __/ _ \ '__|
    | | | | (_| | (_|  __/ |   
    |_|_|  \__,_|\___\___|_|   
```

## The Namesake

Our spimbot is named Tracer. Namely, it can trace the setpoint on the map and move to a target.


## Strategies and Optimization
  Kernal Detection:
        Tracer can spirally detect the kernel from near to far in an 8x8 grid.
        Originally, we detect the target using row traversal, 
        which will potentially cause Trace to move to a further target instead of the nearest one.
  
  Basic Movement: In the very first few cycles, we hard code the Tracer to make it enter the central part of the ear map where it has less chance to bonk on the wall. Then Tracer finds targets using its spiral detection.
  
  Bonking:
        The tracer will never bonk a wall. Tracer can track the setpoints on the map.
        Mostly, setpoints are inside the "corridors" and some special space where Tracer is likely to bonk on the wall.
        So setpoints are the grids where Tracer can advance or withdraw.

  Move to a Target:
        Usually, when there is no barricade between Tracer and the nearest target, it can move directly to the target.
        However, in some cases, there is a wall between them. We can let it bonk the wall and wait for the next nearest target occurs.
        But it leads to a random, unpredictable result. And this cycle penalty is much more than finding a solution. 


## License
[MIT](https://choosealicense.com/licenses/mit/)