irq_vektor_porta:
irq_vektor_portb:
irq_vektor_portc:
irq_vektor_portd:
irq_vektor_porte:
irq_vektor_portf:
irq_vektor_terminal:

irq_vektor_adc0seq0:
irq_vektor_adc0seq1:
irq_vektor_adc0seq2:
irq_vektor_adc0seq3:

irq_vektor_timer0a:
irq_vektor_timer0b:
irq_vektor_timer1a:
irq_vektor_timer1b:
irq_vektor_timer2a:
irq_vektor_timer2b:

# fall back to nullhandler
.include "common/isr.s"
