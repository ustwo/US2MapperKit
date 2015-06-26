#!/usr/local/bin/python
import plistlib
import os
import sys
import getopt
import dircache
import glob

FOLDER_INTERNAL_PREFIX = "Classes/Internal/_"
FOLDER_EXTERNAL_PREFIX = "Classes/"

DEFAULT_PROPERTY_COMMENT = "\n/** \n *  No comment provided by engineer. \n */ \n"

PROPERTY_VAR = "	var"

PROPERTY_TYPE_STRING = "String"
PROPERTY_TYPE_DOUBLE = "Double"
PROPERTY_TYPE_FLOAT = "Float"
PROPERTY_TYPE_INT = "Int"
PROPERTY_TYPE_BOOL= "Bool"

IMPORT_FOUNDATION = "import Foundation"

# Generates the unternal and external .m files
# External 0 - Internal '_' prefixed class with all the properties
# External 1 - External class for enhancements.
def generate_file(classname, class_directory, external):

	if external == 0:
		filename = class_directory + 'Internal/_'+ classname + '.swift'
	if external == 1:
		filename = class_directory + classname + '.swift'
		if os.path.exists(filename):   
   			return None

	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")
	
	append_import_staments(classname, outputfile)
	append_compiler_directives(classname, outputfile, external)
	
	if external == 0:
		return outputfile;
	if external == 1:
		return outputfile;

def append_import_staments(classname, headerfile):
		headerfile.write(IMPORT_FOUNDATION + '\n')
		
def append_compiler_directives (classname, headerfile, external):
	if external == 0:
		headerfile.write('\nclass _' + classname + ' {\n\n')
	if external == 1:
		headerfile.write('\nclass ' + classname + ' : _' + classname + ' {\n')


def append_instance_property(classfile, propertyname, datatype, optional):
	#headerfile.write (DEFAULT_PROPERTY_COMMENT)
	if datatype == PROPERTY_TYPE_STRING:
		classfile.write(PROPERTY_VAR + ' ' + propertyname + ' : ' + PROPERTY_TYPE_STRING)
	if datatype == PROPERTY_TYPE_INT:
		classfile.write(PROPERTY_VAR + ' ' + propertyname + ' : ' + PROPERTY_TYPE_INT)
	if datatype == PROPERTY_TYPE_DOUBLE:
		classfile.write(PROPERTY_VAR + ' ' + propertyname + ' : ' + PROPERTY_TYPE_DOUBLE)
	if datatype == PROPERTY_TYPE_FLOAT:
		classfile.write(PROPERTY_VAR + ' ' + propertyname + ' : ' + PROPERTY_TYPE_FLOAT)
	if datatype == PROPERTY_TYPE_BOOL:
		classfile.write(PROPERTY_VAR + ' ' + propertyname + ' : ' + PROPERTY_TYPE_BOOL)
	
	if optional == 1:
		classfile.write('?')
	
	classfile.write('\n')

def append_properties(classfile, mapping, optional):
	
	propertyList = []
	pl = plistlib.readPlist(mapping)
	for key in pl.keys():
		#print 'key - ' + key

		propertytype = ""
		isoptional = 1

		for subkey in pl[key]:
			if subkey == 'type':
				propertytype = pl[key][subkey]
			if subkey == 'nonoptional':
				if pl[key][subkey] == 'true':
					isoptional = 0
		if optional == isoptional:
			propertyList.append(key)
			append_instance_property(classfile, key, propertytype, optional)
	return propertyList

def append_required_initializer(classFile, mapping, optional):
	if optional == 1:
		classFile.write('\n 	required init(')

	pl = plistlib.readPlist(mapping)	
	for key in pl.keys():
		propertytype = ""
		isoptional = 1

		for subkey in pl[key]:
			if subkey == 'type':
				propertytype = pl[key][subkey]
			if subkey == 'nonoptional':
				if pl[key][subkey] == 'true':
					isoptional = 0
		if optional == isoptional:
			classFile.write('_' + key  + ' : AnyObject')
			if optional == 1:
				classFile.write('?,\n 				  ')
			if optional == 0:
				if pl.keys()[-1] != key:
					classFile.write(',\n 				  ')
				else:
					classFile.write(') {\n')

def append_convenience_initializer(classFile, mapping, optional):
	if optional == 1:
		classFile.write(' 	convenience init?(_ dictionary: NSDictionary) {')
		classFile.write('\n 		let dynamicTypeString = String(self.dynamicType)')
		classFile.write('\n 		let className = dynamicTypeString.componentsSeparatedByString(".").last')
		classFile.write('\n\n 		if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {')
		classFile.write('\n 			self.init(')

	pl = plistlib.readPlist(mapping)
		
	firstlinePropertyAppended = 0	
	for key in pl.keys():
		#print 'key - ' + key

		propertytype = ""
		isoptional = 1

		for subkey in pl[key]:
			if subkey == 'type':
				propertytype = pl[key][subkey]
			if subkey == 'nonoptional':
				if pl[key][subkey] == 'true':
					isoptional = 0
		if optional == isoptional:
			#if firstlinePropertyAppended == 0:
			if optional == 1:
				if pl.keys()[1] == key:
					classFile.write('_' + key  + ' : valuesDict["' + key + '"]!')
				else:
					classFile.write('          _' + key  + ' : valuesDict["' + key + '"]!')

				classFile.write(',\n 			')
			if optional == 0:
				classFile.write('          _' + key  + ' : valuesDict["' + key + '"]!')
				if pl.keys()[-1] != key:
					classFile.write(',\n 			')
				else:
					classFile.write(') \n 		} else {\n 			return nil\n 		}\n 	}')

def append_initializer_value_assignments(classFile, mapping, optional):
	if optional == 1:
		classFile.write('\n 			')

	pl = plistlib.readPlist(mapping)

	for key in pl.keys():
		#print 'key - ' + key
		propertytype = ""
		isoptional = 1

		for subkey in pl[key]:
			if subkey == 'type':
				propertytype = pl[key][subkey]
			if subkey == 'nonoptional':
				if pl[key][subkey] == 'true':
					isoptional = 0
		if optional == isoptional:

			classFile.write(key + ' = UTMapper.typeCast(_' + key + ')')
			if optional == 1:
				classFile.write('\n 			')
			if optional == 0:
				if pl.keys()[-1] != key:
					classFile.write('!\n 			')
				else:
					classFile.write('!\n 	}\n\n')


# Append } to the end of a file and close it
def close_file(headerfile):
	headerfile.write('\n} ')
	headerfile.close();

def generate_model(mappinglist, output_directory):
	internal_message = "\nUS2Mapper Regenerated the following model objects:\n"
	external_message = ""

	for mapping in mappinglist:
		#classname = mapping.split('/', 1 )[-1].split('.', 1 )[0]
		filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
		classname = filename.split('.', 1 )[0]

		internal = generate_file(classname, output_directory, 0)
		external = generate_file(classname, output_directory, 1)

		append_properties(internal, mapping, 1)
		internal.write('\n')
		append_properties(internal, mapping, 0)

		append_required_initializer(internal, mapping, 1)
		append_required_initializer(internal, mapping, 0)

		append_initializer_value_assignments(internal, mapping, 1)
		append_initializer_value_assignments(internal, mapping, 0)

		append_convenience_initializer(internal, mapping, 1)
		append_convenience_initializer(internal, mapping, 0)
		
		internal_message = internal_message + '\nClasses\Internal\_' + classname + '.swift'
		
		if external is not None:
			external_message = external_message + '\nClasses\\' + classname + '.swift'
			close_file (external)
		close_file(internal)
	if len(external_message) > 0:
		external_message = external_message + '\n'
	print internal_message
	print external_message
	
def main(argv):
   inputfile = ''
   outputfile = ''
   try:
      opts, args = getopt.getopt(argv,"hi:o:",["mapdir=","classdir="])
   except getopt.GetoptError:
      print 'test.py -i <mapdir> -o <classdir>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'test.py -i <mapdir> -o <classdir>'
         sys.exit()
      elif opt in ("-i", "--mapdir"):
         mapdir = arg
      elif opt in ("-o", "--classdir"):
         classdir = arg

   mappinglist = glob.glob(mapdir + "*.plist")
   generate_model(mappinglist, classdir)

if __name__ == "__main__":
   main(sys.argv[1:])





