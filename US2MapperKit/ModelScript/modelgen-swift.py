#!/usr/local/bin/python
import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands
from mod_pbxproj import XcodeProject

FOLDER_INTERNAL_PREFIX = "Classes/Internal/_"
FOLDER_EXTERNAL_PREFIX = "Classes/"

PROPERTY_TYPE_STRING 		= "String"
PROPERTY_TYPE_DOUBLE 		= "Double"
PROPERTY_TYPE_FLOAT 		= "Float"
PROPERTY_TYPE_INT 			= "Int"
PROPERTY_TYPE_BOOL			= "Bool"
PROPERTY_TYPE_ARRAY			= "Array"
PROPERTY_TYPE_DICTIONARY	= "Dictionary"

NATIVE_PROPERTY_TYPES = [PROPERTY_TYPE_STRING, PROPERTY_TYPE_DOUBLE, PROPERTY_TYPE_FLOAT, PROPERTY_TYPE_INT, PROPERTY_TYPE_BOOL]

MAPPING_KEY_TYPE 				= "type"
MAPPING_KEY_DEFAULT 			= "default"
MAPPING_KEY_KEY 				= "key"
MAPPING_KEY_NONOPTIONAL 		= "nonoptional"
MAPPING_KEY_MAPPER				= "mapper"
MAPPING_KEY_COLLECTION_SUBTYPE	= "collection_subtype"

# Default Strings
STRING_IMPORT_FOUNDATION 	= "import Foundation\n"
STRING_IMPORT_MAPKIT 		= "import US2MapperKit\n"
STRING_REQUIRED_INIT_START 	= "\n 	required init("
STRING_CONVENIENCE_INIT_START 	= "\n 	required init("
STRING_FAILABLE_INIT_START = ' 	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {\n\n 		let dynamicTypeString = "\(self.dynamicType)"\n 		let className = dynamicTypeString.componentsSeparatedByString(".").last\n\n 		if let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {'
STRING_FAILABLE_INIT_SUPER_START = '	\n 			self.init('
STRING_FILE_INTRO = '// US2Mapper Generated Model\n// UPDATE LISCENSE HERE\n\n'
STRING_PROPERTY_VAR = "	var"

STRING_CLASS_FROM_STRING_METHOD 	= "	override class func classFromString(classname : String, data : Dictionary<String, AnyObject>) -> AnyObject? {\n 		switch classname {\n"

def generate_model(mappinglist, output_directory):
	
	for mapping in mappinglist:

		filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
		classname = filename.split('.', 1 )[0]
		mappingPlist = plistlib.readPlist(mapping)
		validate_class_mapping_configuration(classname, mappingPlist)
		
		generate_external_file_if_needed(classname, output_directory)
		internalClassFile = generate_internal_file(classname, output_directory)
		
		append_property_definitions(internalClassFile, mappingPlist)
		append_required_initializer(internalClassFile, mappingPlist)

		append_failable_initializer(internalClassFile, mappingPlist)
		close_file(internalClassFile)

	generate_internal_instantiator_file(mappinglist, output_directory)

	
	
def xcode_version():
	status, xcodeVersionString = commands.getstatusoutput("xcodebuild -version")
	if xcodeVersionString.find("Xcode 7.")  != -1:
		return 7.0
	else:
		return 6.0

def generate_internal_file(classname, class_directory):
	filename = class_directory + 'Internal/_'+ classname + '.swift'
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")
	outputfile.write(STRING_IMPORT_FOUNDATION)
	outputfile.write(STRING_IMPORT_MAPKIT)
	
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
	outputfile.write('\nclass ' + classname + ' : _' + classname + ' {\n\n}')
	outputfile.close();


def append_mapper_method_definitions(classfile, mappinglist):
	
	distinctMapperClassDefinitions = []

	for mappingPath in mappinglist:
		mappingPlist = plistlib.readPlist(mappingPath)
		mappingKeys = mappingPlist.keys()
	
		for propertyName in mappingKeys:
			if MAPPING_KEY_MAPPER in mappingPlist[propertyName].keys():
				mapperClass = mappingPlist[propertyName][MAPPING_KEY_MAPPER]
				if mapperClass not in distinctMapperClassDefinitions:
					distinctMapperClassDefinitions.append(mapperClass)

	for mapperClass in distinctMapperClassDefinitions:
		classfile.write('	override class func transformValues(transformer : String, values : [AnyObject]) -> AnyObject? {\n		switch transformer {\n')
		classfile.write('			case \"' + mapperClass + '\":\n 				return ' + mapperClass +'.transformValues(values)')
		classfile.write('\n 			default:\n 			 	return nil\n')
		classfile.write('		}\n 	}\n')

def generate_internal_instantiator_file(mappingPlist, output_directory):
	filename = output_directory + 'Internal/US2Mapper.swift'
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")
	outputfile.write(STRING_FILE_INTRO)
	outputfile.write(STRING_IMPORT_FOUNDATION)
	outputfile.write(STRING_IMPORT_MAPKIT)
	
	outputfile.write('\nclass US2Mapper : _US2Mapper {\n\n')

	outputfile.write(STRING_CLASS_FROM_STRING_METHOD)
	classnames = []

	for mapping in mappingPlist:
		filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
		classname = filename.split('.', 1 )[0]
		classnames.append(classname)
	
	for classname in classnames:
		outputfile.write('		case \"' + classname + '\":\n 			return US2Mapper.create' + classname + 'Instance(data)\n' )

	outputfile.write('		default:\n 			return nil\n 		}\n 	}\n\n' )

	for classname in classnames:
		outputfile.write('	class func create' + classname + 'Instance(data : Dictionary<String, AnyObject>) -> AnyObject? {\n 			return ' + classname + '(data) \n 	}\n\n ')

	append_mapper_method_definitions (outputfile, mappingPlist)
	close_file(outputfile)


def append_property_definitions(classfile, mappingPlist):
	mappingKeys = mappingPlist.keys()
	
	# Append Optional Properties 
	for propertyName in mappingKeys:
		
		propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]

		if propertyType == PROPERTY_TYPE_ARRAY:
			
			collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]

			if MAPPING_KEY_NONOPTIONAL not in mappingPlist[propertyName].keys():
				append_array_instance_property(classfile, propertyName, propertyType, collectionSubtype, 1)
			else:
				if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] != 'true':
					append_array_instance_property(classfile, propertyName, propertyType, collectionSubtype, 1)
		elif propertyType == PROPERTY_TYPE_DICTIONARY:
			
			collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]

			if MAPPING_KEY_NONOPTIONAL not in mappingPlist[propertyName].keys():
				append_dictionary_instance_property(classfile, propertyName, propertyType, collectionSubtype, 1)
			else:
				if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] != 'true':
					append_dictionary_instance_property(classfile, propertyName, propertyType, collectionSubtype, 1)
		else:
			if MAPPING_KEY_NONOPTIONAL not in mappingPlist[propertyName].keys():
				append_instance_property(classfile, propertyName, propertyType, 1)
			else:
				if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] != 'true':
					append_instance_property(classfile, propertyName, propertyType, 1)
	
	classfile.write('\n')

	# Append Non-Optional Properties 
	for propertyName in mappingKeys:
		
		propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]
		
		if propertyType == PROPERTY_TYPE_ARRAY:
			collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
			if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
				if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
					append_array_instance_property(classfile, propertyName, propertyType, collectionSubtype, 0)
		
		elif propertyType == PROPERTY_TYPE_DICTIONARY:
			collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
			if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
				if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
					append_dictionary_instance_property(classfile, propertyName, propertyType, collectionSubtype, 0)
		else:
			if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
				if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
					append_instance_property(classfile, propertyName, propertyType, 0)


def append_instance_property(classfile, propertyname, datatype, optional):
	classfile.write(STRING_PROPERTY_VAR + ' ' + propertyname + ' : ' + datatype)
	
	if optional == 1:
		classfile.write('?')
	
	classfile.write('\n')

def append_array_instance_property(classfile, propertyname, datatype, collectionSubtype, optional):
	classfile.write(STRING_PROPERTY_VAR + ' ' + propertyname + ' : [' + collectionSubtype + ']')
	
	if optional == 1:
		classfile.write('?')
	
	classfile.write('\n')

def append_dictionary_instance_property(classfile, propertyname, datatype, collectionSubtype, optional):
	classfile.write(STRING_PROPERTY_VAR + ' ' + propertyname + ' : Dictionary<String,' + collectionSubtype + '>')
	
	if optional == 1:
		classfile.write('?')
	
	classfile.write('\n')

def append_required_initializer(classFile, mappingPlist):
	classFile.write(STRING_REQUIRED_INIT_START)
	
	mappingKeys = mappingPlist.keys()
	firstPropertyWritten = False

	#Append Non-Optional Properties
	for propertyName in mappingKeys:
		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				append_required_initializer_line_break(classFile, firstPropertyWritten)
				propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]
				append_required_initializer_non_optional_property(classFile, mappingPlist, propertyName, propertyType)
				firstPropertyWritten = True
	
	classFile.write(') {\n 			')	
	append_required_initializer_value_assignments(classFile, mappingPlist)

def append_required_initializer_value_assignments(classFile, mappingPlist):
	mappingKeys = mappingPlist.keys()

	#Append Non-Optional Properties
	for propertyName in mappingKeys:
		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				classFile.write('\n 			')
				classFile.write(propertyName + ' = _' + propertyName )
	
	classFile.write('\n 	}\n\n')	


def append_required_initializer_non_optional_property(classFile, mappingPlist, propertyName, propertyType):
	if propertyType == PROPERTY_TYPE_ARRAY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('_' + propertyName  +  ' : [ ' + collectionSubtype + ']')
	elif propertyType == PROPERTY_TYPE_DICTIONARY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('_' + propertyName  +  ' : Dictionary<String, ' + collectionSubtype + '>')
	else:
		classFile.write('_' + propertyName  + ' : ' + propertyType + '')

def append_required_initializer_line_break(classFile, firstPropertyWritten):
	if firstPropertyWritten == True:
			classFile.write(',\n 				  ')

def append_failable_initializer_tempValues(classFile, mappingPlist):
	mappingKeys = mappingPlist.keys()
	firstPropertyWritten = False	
	classFile.write('\n')

	#Append Non-Optional Properties
	for propertyName in mappingKeys:
		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				classFile.write('\n')
				propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]
				append_failable_initializer_non_optional_property_typecast(classFile, mappingPlist, propertyName, propertyType)
				firstPropertyWritten = True
	
	classFile.write('\n')

def append_failable_initializer_optional_temp_properties(classFile, mappingPlist, propertyName, propertyType):
	if propertyType == PROPERTY_TYPE_ARRAY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('			var temp_' + propertyName  + ' : [' + collectionSubtype + ']?')
	elif propertyType == PROPERTY_TYPE_DICTIONARY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('			var temp_' + propertyName  + ' : Dictionary<String, ' + collectionSubtype + '>?')
	else:
		classFile.write('			var temp_' + propertyName  + ' : ' + propertyType + '?' )

def append_failable_initializer_non_optional_property_typecast(classFile, mappingPlist, propertyName, propertyType):
	if propertyType == PROPERTY_TYPE_ARRAY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('			let temp_' + propertyName  + ' : [' + collectionSubtype + ']' + '  = US2Mapper.typeCast(valuesDict["' + propertyName + '"])!')
	elif propertyType == PROPERTY_TYPE_DICTIONARY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('			let temp_' + propertyName  + ' : Dictionary<String, ' + collectionSubtype + '>' + ' = US2Mapper.typeCast(valuesDict["' + propertyName + '"])!')
	else:
		classFile.write('			let temp_' + propertyName  + ' : ' + propertyType  + ' = US2Mapper.typeCast(valuesDict["' + propertyName + '"])!')

def append_failable_initializer_typecasting(classFile, mappingPlist):
	
	mappingKeys = mappingPlist.keys()
	firstPropertyWritten = False

	for propertyName in mappingKeys:
		propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]
		
		if MAPPING_KEY_NONOPTIONAL not in mappingPlist[propertyName].keys():
			classFile.write('\n')
			append_failable_typecast_unwrap_statement(classFile, mappingPlist, propertyName, propertyType)
			firstPropertyWritten = True
		else:
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] != 'true':
				classFile.write('\n')
				append_failable_typecast_unwrap_statement(classFile, mappingPlist, propertyName, propertyType)
				firstPropertyWritten = True


def append_failable_typecast_unwrap_statement(classFile, mappingPlist, propertyName, propertyType):
	if propertyType == PROPERTY_TYPE_ARRAY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('			if let unwrapped_' + propertyName  + ' : AnyObject = valuesDict["' + propertyName + '"] as AnyObject? {\n 				' + propertyName + ' = US2Mapper.typeCast(unwrapped_' + propertyName + ')\n 			}\n')
	elif propertyType == PROPERTY_TYPE_DICTIONARY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('			if let unwrapped_' + propertyName + ' : AnyObject = valuesDict["' + propertyName + '"]  as AnyObject? {\n 					' + propertyName + ' = US2Mapper.typeCast(unwrapped_' + propertyName + ')\n 			}\n')
	else:
		classFile.write('			if let unwrapped_' + propertyName + ' : AnyObject = valuesDict["' + propertyName + '"] as AnyObject? {\n 					' + propertyName + ' = US2Mapper.typeCast(unwrapped_' + propertyName + ')\n 			}\n')
	

def append_failable_initializer(classFile, mappingPlist):
	
	classFile.write(STRING_FAILABLE_INIT_START)
	append_failable_initializer_tempValues(classFile, mappingPlist)
	
	classFile.write(STRING_FAILABLE_INIT_SUPER_START)
	
	mappingKeys = mappingPlist.keys()
	firstPropertyWritten = False
	classFile.write('')
	#Append Non-Optional Properties
	for propertyName in mappingKeys:
		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				append_failable_initializer_line_break(classFile, firstPropertyWritten)
				classFile.write('_' + propertyName  + ' : temp_' + propertyName + '')
				firstPropertyWritten = True
	
	classFile.write(') \n 		')
	append_failable_initializer_typecasting(classFile, mappingPlist)

	if xcode_version() == 6.0:

		classFile.write(' \n 		} else {\n 			self.init(')

		firstPropertyWritten = False

		# Append Non-Optional Properties 
		for propertyName in mappingKeys:
			
			propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]
			
			if propertyType == PROPERTY_TYPE_ARRAY:
				collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
				if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
					if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
						append_failable_initializer_line_break(classFile, firstPropertyWritten)
						append_array_failed_initialiser_property(classFile, propertyName, propertyType, collectionSubtype, 0)
						firstPropertyWritten = True
			
			elif propertyType == PROPERTY_TYPE_DICTIONARY:
				collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
				if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
					if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
						append_failable_initializer_line_break(classFile, firstPropertyWritten)
						append_dictionary_failed_initialiser_property(classFile, propertyName, propertyType, collectionSubtype, 0)
						firstPropertyWritten = True
			else:
				if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
					if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
						append_failable_initializer_line_break(classFile, firstPropertyWritten)
						append_failed_initialiser_property(classFile, propertyName, propertyType, 0)
						firstPropertyWritten = True

		classFile.write(')\n 			return nil\n 		}\n 	}')
	else:
		classFile.write(' \n 		} else {\n 			return nil\n 		}\n 	}')

	

def append_failed_initialiser_property(classfile, propertyname, datatype, optional):
	
	if datatype not in NATIVE_PROPERTY_TYPES:
		classfile.write('_' + propertyname + ' : ' + datatype + '(Dictionary<String, AnyObject>())!')
	else:
		classfile.write('_' + propertyname + ' : ' + datatype + '()')

	if optional == 1:
		classfile.write('?')

def append_array_failed_initialiser_property(classfile, propertyname, datatype, collectionSubtype, optional):
	classfile.write('_' + propertyname + ' : [' + collectionSubtype + ']()')
	
	if optional == 1:
		classfile.write('?')


def append_dictionary_failed_initialiser_property(classfile, propertyname, datatype, collectionSubtype, optional):
	classfile.write( '_' + propertyname + ' : Dictionary<String,' + collectionSubtype + '>()')
	
	if optional == 1:
		classfile.write('?')

def append_failable_initializer_line_break(classFile, firstPropertyWritten):
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
					if MAPPING_KEY_MAPPER not in mappingPlist[propertyName].keys():
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

