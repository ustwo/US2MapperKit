#!/usr/local/bin/python
import plistlib
import os
import sys
import getopt
import dircache
import glob

FOLDER_INTERNAL_PREFIX = "Classes/Internal/_"
FOLDER_EXTERNAL_PREFIX = "Classes/"

PROPERTY_TYPE_STRING 	= "String"
PROPERTY_TYPE_DOUBLE 	= "Double"
PROPERTY_TYPE_FLOAT 	= "Float"
PROPERTY_TYPE_INT 		= "Int"
PROPERTY_TYPE_BOOL		= "Bool"

NATIVE_PROPERTY_TYPES = [PROPERTY_TYPE_STRING, PROPERTY_TYPE_DOUBLE, PROPERTY_TYPE_FLOAT, PROPERTY_TYPE_INT, PROPERTY_TYPE_BOOL]

MAPPING_KEY_TYPE 		= "type"
MAPPING_KEY_DEFAULT 	= "default"
MAPPING_KEY_KEY 		= "key"
MAPPING_KEY_NONOPTIONAL = "nonoptional"

# Default Strings
STRING_IMPORT_FOUNDATION 	= "import Foundation\n"
STRING_REQUIRED_INIT_START 	= "\n 	required init("
STRING_FAILABLE_INIT_START = ' 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {\n 		let dynamicTypeString = String(self.dynamicType)\n 		let className = dynamicTypeString.componentsSeparatedByString(".").last\n\n 		if let valuesDict = UTMapper.parseJSONResponse(className!, data : dictionary) {\n 			self.init('
STRING_PROPERTY_VAR = "	var"

STRING_CLASS_FROM_STRING_METHOD 	= "	class func classFromString(classname : String, data : Dictionary<String, AnyObject>) -> AnyObject? {\n 		switch classname {\n"

def generate_model(mappinglist, output_directory):
	for mapping in mappinglist:
		
		filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
		classname = filename.split('.', 1 )[0]
		mappingPlist = plistlib.readPlist(mapping)
		validate_class_mapping_configuration(classname, mappingPlist)
		
		generate_external_file_if_needed(classname, output_directory)

		internalClassFile = generate_external_file(classname, output_directory)
		
		append_property_definitions(internalClassFile, mappingPlist)
		append_required_initializer(internalClassFile, mappingPlist)
		append_convenience_initializer(internalClassFile, mappingPlist)

		close_file(internalClassFile)

	generate_internal_instantiator_file(mappinglist, output_directory)

def generate_external_file(classname, class_directory):
	filename = class_directory + 'Internal/_'+ classname + '.swift'
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")
	outputfile.write(STRING_IMPORT_FOUNDATION)
	
	outputfile.write('\nclass _' + classname + ' {\n\n')
	return outputfile;


def generate_external_file_if_needed(classname, class_directory):
	filename = class_directory + classname + '.swift'
	if os.path.exists(filename):   
   			return None
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")
	outputfile.write(STRING_IMPORT_FOUNDATION)
	outputfile.write('\nclass ' + classname + ' : _' + classname + ' {\n}')
	outputfile.close();

def generate_internal_instantiator_file(mappingPlist, output_directory):
	filename = output_directory + 'Internal/_UTMapperClassInstantiator.swift'
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")
	outputfile.write(STRING_IMPORT_FOUNDATION)
	
	outputfile.write('\nclass _UTMapperClassInstantiator {\n\n')

	outputfile.write(STRING_CLASS_FROM_STRING_METHOD)
	classnames = []

	for mapping in mappingPlist:

		filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
		classname = filename.split('.', 1 )[0]
		classnames.append(classname)
	
	for classname in classnames:
		outputfile.write('		case \"' + classname + '\":\n 			return _UTMapperClassInstantiator.create' + classname + 'Instance(data)\n' )

	outputfile.write('		default:\n 			return nil\n 		}\n 	}\n\n' )

	for classname in classnames:
		outputfile.write('	class func create' + classname + 'Instance(data : Dictionary<String, AnyObject>) -> AnyObject? {\n 			return ' + classname + '(data) \n 	}\n\n ')

	close_file(outputfile)


def append_property_definitions(classfile, mappingPlist):
	mappingKeys = mappingPlist.keys()
	
	# Append Optional Properties 
	for propertyName in mappingKeys:
		
		propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]

		if MAPPING_KEY_NONOPTIONAL not in mappingPlist[propertyName].keys():
			append_instance_property(classfile, propertyName, propertyType, 1)
		else:
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] != 'true':
				append_instance_property(classfile, propertyName, propertyType, 1)
	
	classfile.write('\n')

	# Append Non-Optional Properties 
	for propertyName in mappingKeys:
		
		propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]
		
		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				append_instance_property(classfile, propertyName, propertyType, 0)


def append_instance_property(classfile, propertyname, datatype, optional):
	
	classfile.write(STRING_PROPERTY_VAR + ' ' + propertyname + ' : ' + datatype)
	
	if optional == 1:
		classfile.write('?')
	
	classfile.write('\n')


def append_required_initializer(classFile, mappingPlist):
	classFile.write(STRING_REQUIRED_INIT_START)
	
	mappingKeys = mappingPlist.keys()
	firstPropertyWritten = False

	#Append Optional Properties 
	for propertyName in mappingKeys:
		if MAPPING_KEY_NONOPTIONAL not in mappingPlist[propertyName].keys():
			append_required_initializer_line_break(classFile, firstPropertyWritten)
			classFile.write('_' + propertyName  + ' : AnyObject?')
			firstPropertyWritten = True
		else:
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] != 'true':
				append_required_initializer_line_break(classFile, firstPropertyWritten)
				classFile.write('_' + propertyName  + ' : AnyObject?')
				firstPropertyWritten = True
	
	#Append Non-Optional Properties
	for propertyName in mappingKeys:
		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				append_required_initializer_line_break(classFile, firstPropertyWritten)
				classFile.write('_' + propertyName  + ' : AnyObject')
				firstPropertyWritten = True
	
	classFile.write(') {\n\n 			')	
	append_required_initializer_value_assignments(classFile, mappingPlist)


def append_required_initializer_line_break(classFile, firstPropertyWritten):
	if firstPropertyWritten == True:
			classFile.write(',\n 				  ')


def append_required_initializer_value_assignments(classFile, mappingPlist):
	mappingKeys = mappingPlist.keys()

	#Append Optional Properties 
	for propertyName in mappingKeys:
		if MAPPING_KEY_NONOPTIONAL not in mappingPlist[propertyName].keys():
			classFile.write(propertyName + ' = UTMapper.typeCast(_' + propertyName + ')\n 			')
		else:
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] != 'true':
				classFile.write(propertyName + ' = UTMapper.typeCast(_' + propertyName + ')\n 			')
	
	#Append Non-Optional Properties
	for propertyName in mappingKeys:
		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				classFile.write(propertyName + ' = UTMapper.typeCast(_' + propertyName + ')!\n 			')
	
	classFile.write('\n 	}\n\n')	


def append_convenience_initializer(classFile, mappingPlist):
	
	classFile.write(STRING_FAILABLE_INIT_START)

	mappingKeys = mappingPlist.keys()
	firstPropertyWritten = False

	#Append Optional Properties 
	for propertyName in mappingKeys:
		if MAPPING_KEY_NONOPTIONAL not in mappingPlist[propertyName].keys():
			append_convenience_initializer_line_break(classFile, firstPropertyWritten)
			classFile.write('_' + propertyName  + ' : valuesDict["' + propertyName + '"]!')
			firstPropertyWritten = True
		else:
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] != 'true':
				append_convenience_initializer_line_break(classFile, firstPropertyWritten)
				classFile.write('_' + propertyName  + ' : valuesDict["' + propertyName + '"]!')
				firstPropertyWritten = True
	
	#Append Non-Optional Properties
	for propertyName in mappingKeys:
		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				append_convenience_initializer_line_break(classFile, firstPropertyWritten)
				classFile.write('_' + propertyName  + ' : valuesDict["' + propertyName + '"]!')
				firstPropertyWritten = True
	
	classFile.write(') \n 		} else {\n 			return nil\n 		}\n 	}')
	
def append_convenience_initializer_line_break(classFile, firstPropertyWritten):
	if firstPropertyWritten == True:
			classFile.write(',\n 				      ')


def close_file(headerfile):
	headerfile.write('\n} ')
	headerfile.close();


def validate_class_mapping_configuration(classname, mappingPlist):

	mapping_property_key = ""

	for propertyName in mappingPlist.keys():
		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				if MAPPING_KEY_TYPE in mappingPlist[propertyName].keys():
					mappingtype = mappingPlist[propertyName][MAPPING_KEY_TYPE]
					if mappingtype in NATIVE_PROPERTY_TYPES:
						if MAPPING_KEY_DEFAULT not in mappingPlist[propertyName].keys():
							throw_missing_default_error(classname, MAPPING_KEY_DEFAULT, mappingPlist[propertyName])

		if MAPPING_KEY_TYPE not in mappingPlist[propertyName].keys():
			throw_missing_type_error(classname, MAPPING_KEY_TYPE, mappingPlist[propertyName])

		if MAPPING_KEY_KEY not in mappingPlist[propertyName].keys():
			throw_missing_json_key_error(classname, MAPPING_KEY_KEY, mappingPlist[propertyName])
	
def print_default_error_header(classname, mapping):
	print "\n\nUS2Mapper Error: Invalid Configuration (" + classname + ".plist)\n\n"
	print mapping
	print "\n"


def throw_missing_default_error(classname, propertykey, mapping):
	print_default_error_header(classname, mapping)
	print "The mapping configuration for " + propertykey + " property is defined as non-optional. \nAll non optional properties must specify a 'default' value configuration.\n\n"
	raise Exception('Invalid Configuration')


def throw_missing_type_error(classname, propertykey, mapping):
	print_default_error_header(classname, mapping)
	print "The mapping configuration for the " + propertykey + " property is missing the type configuration.\nAll properties must specify a 'type' value.\n\n\n\n"
	raise Exception('Invalid Configuration')


def throw_missing_json_key_error(classname, propertykey, mapping):
	print_default_error_header(classname, mapping)
	print "The mapping configuration for the " + propertykey + " property is missing the key configuration.\nAll properties must specify a 'key' value to map against value in a dictionary.\n\n"
	raise Exception('Invalid Configuration')


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


