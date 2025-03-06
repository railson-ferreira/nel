class PubspecYamlUtils{
  static String? getName(String content){
    final lines = content.split('\n');
    for(final line in lines){
      if(line.trim().startsWith('name:')){
        final value =  line.split(':')[1].trim();
        if (value.isEmpty) return null;
        return value;
      }
    }
    return null;
  }

  static String? getVersion(String content){
    final lines = content.split('\n');
    for(final line in lines){
      if(line.trim().startsWith('version:')){
        final value =  line.split(':')[1].trim();
        if (value.isEmpty) return null;
        return value;
      }
    }
    return null;
  }
}