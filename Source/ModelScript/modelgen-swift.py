#!/usr/local/bin/python
import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands

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

STRING_IMPORT_FOUNDATION 	= "import Foundation\n"
STRING_REQUIRED_INIT_START 	= "\n\trequired init("
STRING_FAILABLE_INIT_START = '\tconvenience init?(_ dictionary: Dictionary<String, AnyObject>) {\n\n\t\tlet dynamicTypeString = "\(self.dynamicType)"\n\t\tlet className = dynamicTypeString.componentsSeparatedByString(".").last\n\n\t\tif let valuesDict = US2Mapper.parseJSONResponse(className!, data : dictionary) {'
STRING_FAILABLE_INIT_SUPER_START = '\t\n\t\t\tself.init('
STRING_FILE_INTRO = '// US2Mapper Generated Model\n// UPDATE LISCENSE HERE\n\n'
STRING_PROPERTY_VAR = "	var"

STRING_CLASS_FROM_STRING_METHOD 	= "	override class func classFromString(classname : String, data : Dictionary<String, AnyObject>) -> AnyObject? {\n\t\tswitch classname {\n"

STRING_USMAPPER_IMPORT 			= "import US2MapperKit\n"
STRING_USMAPPER_INHERITENCE 	= "\nclass US2Mapper : _US2Mapper {\n\n"

def generate_model(mappinglist, output_directory, version):
	
	for mapping in mappinglist:
		filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
		classname = filename.split('.', 1 )[0]
		
		mappingPlist = plistlib.readPlist(mapping)
		
		validate_class_mapping_configuration(classname, mappingPlist)
		
		generate_internal_file(mappingPlist, classname, output_directory)
		generate_external_file_if_needed(classname, output_directory)

	generate_internal_instantiator_file(mappinglist, output_directory)


'''
External Model File Generation
'''
def generate_external_file_if_needed(classname, class_directory):
	
	filename = class_directory + classname + '.swift'
	
	if os.path.exists(filename):   
   			return None
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")

	outputfile.write(STRING_IMPORT_FOUNDATION + '\nclass ' + classname + ' : _' + classname + ' {\n\n}')
	outputfile.close();


'''
Internal Model File Generation
'''
def generate_internal_file(mappingPlist, classname, class_directory):
	
	filename = class_directory + 'Internal/_'+ classname + '.swift'
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")

	outputfile.write(STRING_IMPORT_FOUNDATION + STRING_USMAPPER_IMPORT + '\nclass _' + classname + ' {\n')

	append_optional_property_definitions(outputfile, mappingPlist)
	append_non_optional_property_definitions(outputfile, mappingPlist)
	append_required_initializer(outputfile, mappingPlist)
	append_failable_initializer(outputfile, mappingPlist)
	
	outputfile.write('\n} ')
	outputfile.close();


'''
Appeand Properties
'''
def append_optional_property_definitions(classfile, mappingPlist):
	classfile.write('\n')
	mappingKeys = mappingPlist.keys()
	
	for propertyName in mappingKeys:
		propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]
		collectionSubtype = ''
		
		if MAPPING_KEY_COLLECTION_SUBTYPE in mappingPlist[propertyName].keys():
			collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]

		if propertyType == PROPERTY_TYPE_ARRAY:
			if MAPPING_KEY_NONOPTIONAL not in mappingPlist[propertyName].keys() or mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] != 'true':
				append_array_instance_property(classfile, propertyName, collectionSubtype, True)

		elif propertyType == PROPERTY_TYPE_DICTIONARY:
			if MAPPING_KEY_NONOPTIONAL not in mappingPlist[propertyName].keys() or mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] != 'true':
				append_dictionary_instance_property(classfile, propertyName, collectionSubtype, True)
		else:
			if MAPPING_KEY_NONOPTIONAL not in mappingPlist[propertyName].keys() or mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] != 'true':
				append_instance_property(classfile, propertyName, propertyType, True)


def append_non_optional_property_definitions(classfile, mappingPlist):
	classfile.write('\n')

	for propertyName in mappingPlist.keys():
		propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]
		collectionSubtype = ''

		if MAPPING_KEY_COLLECTION_SUBTYPE in mappingPlist[propertyName].keys():
			collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]

		if propertyType == PROPERTY_TYPE_ARRAY:
			if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys() and mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				append_array_instance_property(classfile, propertyName, collectionSubtype, False)
		
		elif propertyType == PROPERTY_TYPE_DICTIONARY:
			if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys() and mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				append_dictionary_instance_property(classfile, propertyName, collectionSubtype, False)
		else:
			if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys() and mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				append_instance_property(classfile, propertyName, propertyType, False)


def append_instance_property(classfile, propertyname, datatype, optional):
	classfile.write(STRING_PROPERTY_VAR + ' ' + propertyname + ' : ' + datatype + '{}\n'.format('?' if optional else ''))

def append_array_instance_property(classfile, propertyname, collectionSubtype, optional):
	classfile.write(STRING_PROPERTY_VAR + ' ' + propertyname + ' : [' + collectionSubtype + ']{}\n'.format('?' if optional else ''))

def append_dictionary_instance_property(classfile, propertyname, collectionSubtype, optional):
	classfile.write(STRING_PROPERTY_VAR + ' ' + propertyname + ' : Dictionary<String,' + collectionSubtype + '>{}\n'.format('?' if optional else ''))


'''
Append Required Initializer
'''
def append_required_initializer(classFile, mappingPlist):
	classFile.write(STRING_REQUIRED_INIT_START)
	firstPropertyWritten = True

	for propertyName in mappingPlist.keys():
		propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]

		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys() and mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
			append_required_initializer_non_optional_property(classFile, mappingPlist, propertyName, propertyType, firstPropertyWritten)
			firstPropertyWritten = False
	
	classFile.write(') {\n 			')	
	append_required_initializer_value_assignments(classFile, mappingPlist)
	classFile.write('\n\t}\n\n')	


def append_required_initializer_value_assignments(classFile, mappingPlist):
	for propertyName in mappingPlist.keys():
		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys():
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				classFile.write('\n 			')
				classFile.write(propertyName + ' = _' + propertyName )
	
	
def append_required_initializer_non_optional_property(classFile, mappingPlist, propertyName, propertyType, isFirstProperty):
	if propertyType == PROPERTY_TYPE_ARRAY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('{}_'.format('' if isFirstProperty else ',\n\t\t\t\t  ') + propertyName  +  ' : [' + collectionSubtype + ']')
	elif propertyType == PROPERTY_TYPE_DICTIONARY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('{}_'.format('' if isFirstProperty else ',\n\t\t\t\t  ') + propertyName  +  ' : Dictionary<String, ' + collectionSubtype + '>')
	else:
		classFile.write('{}_'.format('' if isFirstProperty else ',\n\t\t\t\t  ') + propertyName  + ' : ' + propertyType)


'''
Append Failable Initializer
'''
def append_failable_initializer(classFile, mappingPlist):
	
	classFile.write(STRING_FAILABLE_INIT_START)

	append_failable_initializer_tempValues(classFile, mappingPlist)
	
	classFile.write(STRING_FAILABLE_INIT_SUPER_START)

	isFirstLine = True

	for propertyName in mappingPlist.keys():
		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys() and mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
			classFile.write('{}_'.format('' if isFirstLine else ',\n\t\t\t\t\t ') + propertyName  + ' : temp_' + propertyName + '')
			isFirstLine = False
	
	classFile.write(') \n\t\t')

	append_failable_initializer_typecasting(classFile, mappingPlist)

	print xcode_version() 

	if xcode_version() == 7.0:
		classFile.write(' \n\t\t} else {\n\t\t\treturn nil\n\t\t}\n\t}')
	else:
		append_swift_1_2_failable_reinitialization(classFile, mappingPlist)


def append_swift_1_2_failable_reinitialization(classFile, mappingPlist):
	
	classFile.write(' \n 		} else {\n 			self.init(')
	isFirstLine = True

	for propertyName in mappingPlist.keys():
		propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]
		collectionSubtype = ''

		if MAPPING_KEY_COLLECTION_SUBTYPE in mappingPlist[propertyName].keys():
			collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]

		if propertyType == PROPERTY_TYPE_ARRAY:
			if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys() and mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				append_array_failed_initialiser_property(classFile, propertyName, propertyType, collectionSubtype, False, isFirstLine)
				isFirstLine = False
		
		elif propertyType == PROPERTY_TYPE_DICTIONARY:
			if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys() and mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				append_dictionary_failed_initialiser_property(classFile, propertyName, propertyType, collectionSubtype, False, isFirstLine)
				isFirstLine = False
		else:
			if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys() and mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
				append_failed_initialiser_property(classFile, propertyName, propertyType, False, isFirstLine)
				isFirstLine = False

	classFile.write(')\n\n\t\t\treturn nil\n\t\t}\n\t}')


def append_failable_initializer_tempValues(classFile, mappingPlist):
	classFile.write('\n')

	for propertyName in mappingPlist.keys():
		if MAPPING_KEY_NONOPTIONAL in mappingPlist[propertyName].keys() and mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] == 'true':
			propertyType = mappingPlist[propertyName][MAPPING_KEY_TYPE]
			append_failable_initializer_non_optional_property_typecast(classFile, mappingPlist, propertyName, propertyType)
	
	classFile.write('\n')


def append_failable_initializer_optional_temp_properties(classFile, mappingPlist, propertyName, propertyType):
	if propertyType == PROPERTY_TYPE_ARRAY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('\t\t\tvar temp_' + propertyName  + ' : [' + collectionSubtype + ']?')
	elif propertyType == PROPERTY_TYPE_DICTIONARY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('\t\t\tvar temp_' + propertyName  + ' : Dictionary<String, ' + collectionSubtype + '>?')
	else:
		classFile.write('\t\t\tvar temp_' + propertyName  + ' : ' + propertyType + '?' )


def append_failable_initializer_non_optional_property_typecast(classFile, mappingPlist, propertyName, propertyType):
	if propertyType == PROPERTY_TYPE_ARRAY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('\n\t\t\tlet temp_' + propertyName  + ' : [' + collectionSubtype + ']' + '  = US2Mapper.typeCast(valuesDict["' + propertyName + '"])!')
	elif propertyType == PROPERTY_TYPE_DICTIONARY:
		collectionSubtype = mappingPlist[propertyName][MAPPING_KEY_COLLECTION_SUBTYPE]
		classFile.write('\n\t\t\tlet temp_' + propertyName  + ' : Dictionary<String, ' + collectionSubtype + '>' + ' = US2Mapper.typeCast(valuesDict["' + propertyName + '"])!')
	else:
		classFile.write('\n\t\t\tlet temp_' + propertyName  + ' : ' + propertyType  + ' = US2Mapper.typeCast(valuesDict["' + propertyName + '"])!')


def append_failable_initializer_typecasting(classFile, mappingPlist):
	for propertyName in mappingPlist.keys():
		if MAPPING_KEY_NONOPTIONAL not in mappingPlist[propertyName].keys():
			append_failable_typecast_unwrap_statement(classFile, propertyName)
		else:
			if mappingPlist[propertyName][MAPPING_KEY_NONOPTIONAL] != 'true':
				append_failable_typecast_unwrap_statement(classFile, propertyName)


def append_failable_typecast_unwrap_statement(classFile, propertyName):
	classFile.write('\n\t\t\tif let unwrapped_' + propertyName + ' : AnyObject = valuesDict["' + propertyName + '"] as AnyObject? {\n\t\t\t\t' + propertyName + ' = US2Mapper.typeCast(unwrapped_' + propertyName + ')\n\t\t\t}\n')

def append_failed_initialiser_property(classfile, propertyname, datatype, optional, isFirstLine):
	if datatype not in NATIVE_PROPERTY_TYPES:
		classfile.write('{}_'.format('' if isFirstLine else ',\n\t\t\t\t  ') + propertyname + ' : ' + datatype + '(Dictionary<String, AnyObject>())!{}'.format('?' if optional else ''))
	else:
		classfile.write('{}_'.format('' if isFirstLine else ',\n\t\t\t\t  ') + propertyname + ' : ' + datatype + '(){}'.format('?' if optional else ''))

def append_array_failed_initialiser_property(classfile, propertyname, datatype, collectionSubtype, optional, isFirstLine):
	classfile.write('{}_'.format('' if isFirstLine else ',\n\t\t\t\t  ') + propertyname + ' : [' + collectionSubtype + '](){}'.format('?' if optional else ''))

def append_dictionary_failed_initialiser_property(classfile, propertyname, datatype, collectionSubtype, optional, isFirstLine):
	classfile.write( '{}_'.format('' if isFirstLine else ',\n\t\t\t\t  ') + propertyname + ' : Dictionary<String,' + collectionSubtype + '>(){}'.format('?' if optional else ''))


'''
Create External US2Mapper Inherited File
'''
def generate_internal_instantiator_file(mappingPlist, output_directory):
	filename = output_directory + 'Internal/US2Mapper.swift'
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")

	outputfile.write(STRING_FILE_INTRO + STRING_IMPORT_FOUNDATION + STRING_USMAPPER_IMPORT + STRING_USMAPPER_INHERITENCE + STRING_CLASS_FROM_STRING_METHOD)

	classnames = []

	for mapping in mappingPlist:
		filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
		classname = filename.split('.', 1 )[0]
		classnames.append(classname)
	
	for classname in classnames:
		outputfile.write('\t\tcase \"' + classname + '\":\n\t\t\treturn US2Mapper.create' + classname + 'Instance(data)\n' )

	outputfile.write('\t\tdefault:\n\t\t\treturn nil\n\t\t}\n\t}\n\n' )

	for classname in classnames:
		outputfile.write('	class func create' + classname + 'Instance(data : Dictionary<String, AnyObject>) -> AnyObject? {\n\t\treturn ' + classname + '(data) \n\t}\n\n ')

	append_mapper_method_definitions (outputfile, mappingPlist)
	outputfile.write('\n} ')
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
		classfile.write('\toverride class func transformValues(transformer : String, values : [AnyObject]) -> AnyObject? {\n\t\tswitch transformer {\n')
		classfile.write('\t\t\tcase \"' + mapperClass + '\":\n\t\t\t\treturn ' + mapperClass +'.transformValues(values)')
		classfile.write('\n\t\t\tdefault:\n\t\t\t\treturn nil\n')
		classfile.write('\t\t}\n\t}')

'''
Validation and System Checks
'''
def validate_class_mapping_configuration(classname, mappingPlist):
	for propertyName in mappingPlist.keys():
		if MAPPING_KEY_TYPE not in mappingPlist[propertyName].keys():
			throw_missing_type_error(classname, MAPPING_KEY_TYPE, mappingPlist[propertyName])

		if MAPPING_KEY_KEY not in mappingPlist[propertyName].keys():
			throw_missing_json_key_error(classname, MAPPING_KEY_KEY, mappingPlist[propertyName])
	
def print_default_error_header(classname, mapping):
	print "\n\nUS2Mapper Error: Invalid Configuration (" + classname + ".plist)\n\n"
	print mapping
	print "\n"

def throw_missing_type_error(classname, propertykey, mapping):
	print_default_error_header(classname, mapping)
	print "The mapping configuration for the " + propertykey + " property is missing the type configuration.\nAll properties must specify a 'type' value.\n\n\n\n"
	raise Exception('Invalid Configuration')

def throw_missing_json_key_error(classname, propertykey, mapping):
	print_default_error_header(classname, mapping)
	print "The mapping configuration for the " + propertykey + " property is missing the key configuration.\nAll properties must specify a 'key' value to map against value in a dictionary.\n\n"
	raise Exception('Invalid Configuration')

def xcode_version():
	status, xcodeVersionString = commands.getstatusoutput("xcodebuild -version")
	if xcodeVersionString.find("Xcode 7.")  != -1:
		return 7.0
	else:
		return 6.0


def main(argv):

   try:
      opts, args = getopt.getopt(argv,"hv:i:o:",["version=", "mapdir=", "classdir="])
   except getopt.GetoptError:
      print 'test.py -v <version> -i <mapdir> -o <classdir>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'test.py -v <version> -i <mapdir> -o <classdir>'
         sys.exit()
      elif opt in ("-v", "--version"):
         version = arg
      elif opt in ("-i", "--mapdir"):
         mapdir = arg
      elif opt in ("-o", "--classdir"):
         classdir = arg

   mappinglist = glob.glob(mapdir + "*.plist") 
   generate_model(mappinglist, classdir, version)

if __name__ == "__main__":
   main(sys.argv[1:])