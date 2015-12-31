import math,sys
from math import pi
import numpy
from numpy import sin
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

def convert2hex_of_xilinx(hex_number,num_of_bits):
	hex_number = hex_number.split('x')
	hex_number = hex_number[1]
	hex_number = str(hex_number)
	hex_number = str(num_of_bits)+"'h"+ hex_number +';'
	return hex_number


#def generate_testbench(value):
	

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
		if i ==9:
			i = 0
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
		x_processor = 0.01*time
		x_float1 = float(x_processor)
		x_processor = ieee754(x_float1)
		x_processor = hex(x_processor)
		x_processor = x_processor.split('x')
		x_processor = x_processor[1]
		x_processor = str(x_processor)
		y_processor = 0.1 + 0.005*time
		y_float1 = float(y_processor)
		y_processor = ieee754(y_float1)
		y_processor = hex(y_processor)
		y_processor = y_processor.split('x')
		y_processor = y_processor[1]
		y_processor = str(y_processor)
		z_float = time*pi/180
		z_float1 = float(z_float)
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
		if i ==0:	
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
		elif i==1:		
			sineh = math.sinh(z_float1)
			sineh = ieee754(sineh)
			sineh = hex(sineh)
			sineh = convert2hex_of_xilinx(sineh,32)
			cosineh = math.cosh(z_float1)
			cosineh = ieee754(cosineh)
			cosineh = hex(cosineh)
			cosineh = convert2hex_of_xilinx(cosineh,32)
			print "\t" +"x_out = "+ str(cosineh)
			print "\t" +"y_out = "+ str(sineh)
		elif i==2:
			atangent = math.atan(y_float1)
			atangent = ieee754(atangent)
			atangent = hex(atangent)
			atangent = convert2hex_of_xilinx(atangent,32)
			print "\t" + str(atangent)
		elif i==3:
			atangenth = math.atanh(y_float1)
			atangenth = ieee754(atangenth)
			atangenth = hex(atangenth)
			atangenth = convert2hex_of_xilinx(atangenth,32)
			print "\t" + str(atangenth)
		elif i==4:
			exponent = math.exp(z_float1)
			exponent = ieee754(exponent)
			exponent = hex(exponent)
			exponent = convert2hex_of_xilinx(exponent,32)

			print "\t" + str(exponent)
		elif i==5:
			squareroot=math.sqrt(math.pow(x_float1,2)+math.pow(y_float1,2))
			squareroot= ieee754(squareroot)
			squareroot= hex(squareroot)
			squareroot =convert2hex_of_xilinx(squareroot,32)
			print "\t" + str(squareroot)
		elif i==6:
			division = y_float1/x_float1
			division = ieee754(division)
			division = hex(division)
			division = convert2hex_of_xilinx(division,32)	
			print "\t" + str(division)
		elif i==7:
			tangent = math.tan(z_float1)
			tangent = ieee754(tangent)
			tangent = hex(tangent)
			tangent = convert2hex_of_xilinx(tangent,32)
			print "\t" + str(tangent)
		elif i==8:
			tangenth = math.tanh(z_float1)
			tangenth = ieee754(tangenth)
			tangenth = hex(tangenth)
			tangenth = convert2hex_of_xilinx(tangenth,32)
			print "\t" + str(tangenth)
				


		
		
	
'''tr = open('theta_rot.txt'w')dc = open('DeltaCir_rot.txt','w')
dh = open('DeltaHyper_rot.txt','w')
kcr = open('KappaCir_rot.txt','w')
khr = open('KappaHyper_rot.txt','w')

#dv = open('Delta_Vec_nonlin.txt','w')
#dlv = open('DeltaLin_Vec.txt','w')
#tcv = open('ThetaCir_Vec.txt','w')
#thv = open('ThetaHyp_Vec.txt','w')
#kcv = open('KappaCir_Vec.txt','w')
#khv = open('KappaHyp_Vec.txt','w')
address = 0

while address <= 255 :
  #extracting relevant bits
  #For nonlinear Vectoring
  #den = (((address & 0x3)<<21) + 0x1FFFFF) + 0x3F800000
  #num = ((address & 0xC)<<19) + 0x3F800000
  #ex  = ((address & 0xF0)>>4)
  
  #for linear vectoring
  #denl = (((address & 0xF)<<19) + 0x7FFFF) + 0x3F800000
  #numl = ((address & 0xF0)<<15) + 0x3F800000
  #print ('%08X \t %08X \t' % (denl,numl))
  #for Rotation
  ze  = (0x7F - ((address & 0xF0)>>4)) << 23	
  zs  = ((address & 0xF)<<19) + ze
  #print ("0x%08X \t 0x%08X" % (zs,ze))

  #numf = ieee754tofloat(num)
  #print ("Numerator (in float): %f" % (numf))
  #denf = ieee754tofloat(den)
  #print ("Denominator (in float): %f" % (denf))
  #zsf  = ieee754tofloat(zs)
  #print ("%f \t %f" % (denf,numf))

  #deltav = (numf/denf)
  theta_r = zs
  #if deltav > +11:
  #  deltav = 0.999999999
  #print hex(ieee754(deltav))
  
  #print address
  #print('%08X \t' % (ieee754(deltav)))
  #dv.write ('%08X \n' % (ieee754(deltav)))
  #print ('%f \t %08X \n' % (deltav,ieee754(deltav)))
  #tcv.write('%08X \n' % (ieee754(math.atan(deltav))))
  #print ('%f \t %08X \n' % (math.atan(deltav),ieee754(math.atan(deltav))))
  #thv.write('%08X \n' % (ieee754(math.atanh(deltav))))
  #print ('%f \t %08X \n' % (math.atanh(deltav),ieee754(math.atanh(deltav))))
  #kcv.write('%08X \n' % (ieee754(math.cos(math.atan(deltav)) + pow(10,-7) )))
  #print ('%f \t %08X \n' % (math.cos(math.atan(deltav)) + pow(10,-7),ieee754(math.cos(math.atan(deltav)) + pow(10,-7) )))
  #khv.write('%08X \n' % (ieee754(math.cosh(math.atanh(deltav)) + pow(10,-7) )))
  #print ('%f \t %08X \n' % (math.cosh(math.atanh(deltav)),ieee754(math.cosh(math.atanh(deltav)))))
  #dlv.write('%08X \n' % (ieee754(deltav)))
  
  #print ('%08X \t' % (theta_r))
    #Writing calculated values into the LUT file for Rotation
  tr.write("%08X\n" % (theta_r))
  #print ("%08X \t %f\n" % (theta_r,ieee754tofloat(theta_r)))
  dc.write("%08X\n" % ((ieee754(math.tan(ieee754tofloat(theta_r))))))
  #print ("%08X \t %f\n" % ((ieee754(math.tan(ieee754tofloat(theta_r)))),math.tan(ieee754tofloat(theta_r))))
  dh.write("%08X\n" % ((ieee754(math.tanh(ieee754tofloat(theta_r))))))
  #print ("%08X \t %f\n" % ((ieee754(math.tanh(ieee754tofloat(theta_r)))),math.tanh(ieee754tofloat(theta_r))))
  kcr.write("%08X\n" % ((ieee754(math.cos(ieee754tofloat(theta_r))) + pow(10,-7) )))
  #print ("%08X \t %f\n" % ((ieee754(math.cos(ieee754tofloat(theta_r)))),math.cos(ieee754tofloat(theta_r))))
  khr.write("%08X\n" % (ieee754(math.cosh(ieee754tofloat(theta_r)) + pow(10,-7) )))
  #print ("%08X \t %f\n" % (ieee754(math.cosh(ieee754tofloat(theta_r))),math.cosh(ieee754tofloat(theta_r))))
  
  #print("%08X\n" % (theta_r))
  #print("%08X\n" % ((ieee754(math.tan(ieee754tofloat(theta_r))))))
  #print("%08X\n" % ((ieee754(math.tanh(ieee754tofloat(theta_r))))))
  #print("%08X\n" % ((ieee754(1/math.cos(ieee754tofloat(theta_r))))))
  address += 1
  #print "done"'''
