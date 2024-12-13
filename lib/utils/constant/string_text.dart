class StringAsset {
  StringAsset._();
  static const MainScreen = "Welcome Home";
  static const scanBtnTop = 'Gym and Equipment';
  static const bodyGym = 'Look up for machine tools at the gym';
  static const scanBtnBottom = 'Foods and Calories';
  static const detailFoods = 'Detail about your foods';
  static const account = 'Account';
  static const prompsGym = """
make the response faster please
with the following image pls  tell me what is this machine in gym pls response back as json object with {
    "name" , "summary", ( make it short )
    "exercise", "set" as string, "rep"  as string , "calories_burn_per_set (50-100cal)  as string ("
    "target_muscles" as  array of string ,
    "instructions"    array of string no need to add note or description of your word no need to return me both at the same time only return either error or the answer  f user submit image that is not related to that pls return error with key code, message as json object 
""";
  static const prompsFoodCalories = '''
make the response faster please
with the following image pls rate my foods and 
response as json object with the following 
fields : rating, title, comment, calories, calcium with it units, 
fat, proteins, sugar as gram , carbohydrates , rating overall 
out of 5 base on healthiness if too much calories or junk food 
rate it low and if it a salad or healthy make it high rating or  , 
 if user submit image that is not related to that pls return error with key code, message as json object 
 pls no need to response with note for me 
 value:'300g', title:'Pizza' i want it to be like this
{
    "rating": 3 as int,
    "title": "",
    "comment": "A classic American favorite, but high in fat and calories." as string make it like 40 words,
    "nutrition_facts":[] as   {
            "iconType": "calories",
            "value": "500-800 kcal",
            "title": "Calories"
        },,
    "isHealthy": true / false,
  
}

  ''';
}
