import lusl.std
import gdi.gui
import gdi.font
def main():
    box(0,0,340,190,11)
    r = 35
    x = 0-r
    y = 0-r
    while (y != r):
      while (x != r):
        if (((x*x) + (y*y)) <= (r*r)):
          box(x+270,y+85,1,1,5)
        x = x + 1
      x = 0-r
      y = y + 1
    box(10, 50, 70, 70, 5)
    x = 160;
    y = 50;
    w = 1;    
    while (w <= 120):
      box(x, y, w, 1, 5);
      y = y + 1;
      x = x - 1;
      w = w + 2;
    vflush()
    breakpoint()
