package tools;

enum Result< T > {
  Ok(result:T);
  Error(message:String);
}
