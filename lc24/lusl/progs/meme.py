import lusl.std
import gdi.gui
import gdi.font
buf = bytes(64)
def main():
    cls(15)
    i = 0
    while i != 0x10:
        box(i*8, 0, 8, 8, i)
        vputs(i*8, 0, 15-i, "0\x001\x002\x003\x004\x005\x006\x007\x008\x009\x00a\x00b\x00c\x00d\x00e\x00f"+i*2)
        i = i + 1
    vputs(10, 10, 2, "Geraldip Pavlov")
    vputs(10, 18, 0,
          "Коллега, подскажите, пожалуйста, когда будет "
          "завершен этот\nэксперимент? В том плане, что, я "
          "полагаю, изучение ОС началось\nиз-за некого рода "
          "интереса к теме, была ли поставлена цель,\nкакое-то "
          "логическое завершение, или это просто будет длиться\n"
          "до тех пор, пока энтузиазм не угаснет?"
        )

    vputs(0, 182, 0, "GovnGram. Powered by GovnPy2(TM)")
    vflush()
    puts("Ответить: ")
    gets(buf)
    vputs(0, 174, 0, buf)
    vflush()
    puts("Нажмите Enter чтобы выйти...")
    gets("")
