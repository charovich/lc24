import lusl.std
import gdi.gui
import gdi.font
def main():
    cls(15)
    tmp = vputs(10, 10, 3, "Govn")
    vputs(tmp, 0, 0, "Py Conf 2025")
    # Do
    vputs(10, 20, 0, "Версия 1")
    box(10, 44, 8 * 15, 8 * 15, 7)
    vputs(10, 44, 0, "push 2\npush 2\npush 2\npop %bx\npop %ax\nmul %ax %bx\npush %ax\npop %bx\npop %ax\nadd %ax %bx\npush %ax")
    # Posle
    vputs(140, 20, 0, "Version 2\n11 lines")
    vputs(140, 36, 0, "50% shorter")
    box(140, 44, 8 * 15, 8 * 15, 7)
    vputs(140, 44, 0, "lda 2\nldb 2\nmul %bx 2\nadd %ax %bx\npush %ax")
    vflush()
    gets("???")
