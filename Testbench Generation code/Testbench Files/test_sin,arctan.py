import math,sys
from math import pi
def ieee754 (a):
	rep = 0
	#sign bit
	if (a<0):
		rep = 1<<31
		a = math.fabs(a)
	if (a >= 1):
		#exponent	
		exp = int(math.log(a,2))	
		rep = rep|((exp+127)<<23)
		
		#mantissa	
		temp = a / pow(2,exp) - 1
		i = 22
		while i>=0:
			temp = temp * 2
			if temp > 1:
				rep = rep | (1<<i)
				temp = temp - 1
			i-=1		
		return rep
	elif ((a<1) and (a!=0)):
		#exponent
		exp = 0
		temp = a
		while temp<1 :
			temp = temp*2
			exp +=1
		rep = rep |((127 - exp)<<23)

		#mantissa
		temp = temp - 1
		i = 22
		while i>=0:
			temp = temp * 2
			if temp > 1:
				rep = rep | (1<<i)
				temp = temp - 1
			i-=1
		return rep
	else :
		return 0			

def ieee754tofloat (a):
  ex = (a & 0x7F800000)>>23
  ex = ex - 127
  i = 1	
  p = 22
  num = 1.0
  #print('%d \n' % (ex))
  while (p != -1) :
    i = 1<<p
    dig = (a & i)>>p
    #print dig
    num += (dig * pow(2,p-23))
    p -= 1
  num = num * pow(2,ex)
  i = 1<<31
  sign = a & i
  if (sign) :
    num = num * -1
  print num
  return num


#def generate_testbench(value):
def convert2hex_of_xilinx(hex_number,num_of_bits):
	hex_number = hex_number.split('x')
	hex_number = hex_number[1]
	hex_number = str(hex_number)
	hex_number = str(num_of_bits)+"'h"+ hex_number +';'
	return hex_number	

if __name__ == "__main__":  

	time =0;
	i = 0;
	j = 0;
	for time in range(0,100):
		i = i+1
		j = j+1
		if j == 255:
			j = 0;
		else:
			j = j;
		if i ==3:
			i = 0
		elif i==1:
			i=i+1
		else:
			i=i
		InsTagIn = j	
		InsTagIn = hex(InsTagIn)
		InsTagIn = InsTagIn.split('x')
		InsTagIn = InsTagIn[1]	
		instagin = str("\tInsTagIn = ")
		InsTagIn = instagin + "8'h"+str(InsTagIn) + ";"
		Opcode = i
		Opcode = hex(Opcode)
		Opcode = Opcode.split('x')
		Opcode = Opcode[1]
		opcode = str("\tOpcode = ")
		Opcode =  opcode +"4'h"+ str(Opcode) +";"
		delay = 20
		delay = str(delay)
		delay = '#' + delay
		x = str("    x_processor= ")
		x = delay +x
		y = str("\ty_processor= ")
		
		z = str("\tz_processor= ")
		#z = delay+z
		'''x_processor = 0.01*time
		x_processor = float(x_processor)
		x_processor = ieee754(x_processor)
		x_processor = hex(x_processor)
		x_processor = x_processor.split('x')
		x_processor = x_processor[1]
		x_processor = str(x_processor)'''
		y_processor = 0.5 + 0.01*time
		y_float1 = float(y_processor)
		y_processor = ieee754(y_float1)
		y_processor = hex(y_processor)
		y_processor = y_processor.split('x')
		y_processor = y_processor[1]
		y_processor = str(y_processor)
		x_processor = str(00000000);
		#y_processor = str(00000000);
		z_processor = time*pi/180
		z_float1 = float(z_processor)
		z_processor = ieee754(z_float1)
		z_processor = hex(z_processor)
		z_processor = z_processor.split('x')
		z_processor = z_processor[1]
		z_processor = str(z_processor)
		x = x+"32'h"+x_processor +";"
		y = y+"32'h"+y_processor +";"
		z = z+"32'h"+z_processor +";"
		print x
		print y
		print z
		print Opcode
		print InsTagIn
		'''if i ==0:	
			sine = math.sin(z_float1)
			sine = ieee754(sine)	
			sine = hex(sine)
			sine = convert2hex_of_xilinx(sine,32)
			cosine = math.cos(z_float1)
			cosine = ieee754(cosine)
			cosine = hex(cosine)
			cosine = convert2hex_of_xilinx(cosine,32)
			print "\t" +"x_out ="+ str(cosine) 
			print "\t" +"y_out ="+ str(sine)
		elif i==2:
			atangent = math.atan(y_float1)
			atangent = ieee754(atangent)
			atangent = hex(atangent)
			atangent = convert2hex_of_xilinx(atangent,32)
			print "\t" +"z_out = " + str(atangent)'''

