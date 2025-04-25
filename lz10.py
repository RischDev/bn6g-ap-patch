from ndspy import lz10
import sys

def int32_to_byte_list_le(x) -> bytearray:
	byte32_string = "{:08x}".format(x)
	data = bytearray.fromhex(byte32_string)
	data.reverse()
	return data

def main():
	args = sys.argv
	isCompress = True
	inputOutput = []
	for arg in args[1:]:
		if arg == "-h" or arg == "-help":
			print("Usage:")
			print("	python lz10.py [-compress | -decompress] infile outfile")
			return
		if arg == "-compress":
			isCompress = True
		elif arg == "-decompress":
			isCompress = False
		else:
			inputOutput.append(arg)
	
	if len(inputOutput) < 2:
		print("Not enough arguments. Please include an input and output file name")
		print("Usage:")
		print("	python lz10.py [-compress | -decompress] infile outfile")
			
		return
	
	with open(inputOutput[0], "rb") as inp:
		data = inp.read()
		if isCompress:
			# Prepend the size of the archive as a 4-byte header
			size = int32_to_byte_list_le(len(data))
			data = size + data
			
			print("Compressing file "+inputOutput[0]+" to "+inputOutput[1])
			lz10.compressToFile(data,inputOutput[1])
		else:
			print("Decompressing file "+inputOutput[0]+" to "+inputOutput[1])
			lz10.decompressToFile(data,inputOutput[1])

if __name__ == "__main__": main()