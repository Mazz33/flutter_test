import "package:flutter/material.dart";

void main()
{
	addGoal(testGoal);
	runApp(MyApp());
}

var userGoals = new Map();
Goal testGoal = new Goal("Test Goal", "This is my test goal case!!");

class MyApp extends StatelessWidget
{
	@override
	Widget build(BuildContext context) {
    return MaterialApp(
			title: "To-do list",
			home: HomePage(
					title: "My To do list"
			),
			theme: ThemeData(
				primaryColor: Colors.red,
			),
		);
  }
}

class HomePage extends StatelessWidget
{
	HomePage({Key key, this.title}) : super(key: key);
	final String title;
	@override
	Widget build(BuildContext context) {
    return Scaffold(
			appBar: AppBar(
				centerTitle: true,
				title: Text(this.title),
			),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: <Widget>[
						Center(
								child: FlatButton(
									child: Text("My List", style: TextStyle(fontSize:35.0)),
									color: Colors.blue,
									textColor: Colors.white,
									onPressed: (){
										Navigator.push(context, MaterialPageRoute(builder: (context) => ViewGoals()));
									},
								)
						),
						Center(
							child: FlatButton(
								child: Text("Add Todo", style: TextStyle(fontSize:27.0)),
								color: Colors.blue,
								textColor: Colors.white,
								onPressed: () {},
							)
						)
					],
				)
			)
		);
  }
}

class Goal //goals added in the To-do list
{
	String name, desc;
	bool finished = false;
	bool status = false; //is the goal started or not
	Goal(this.name, this.desc);

	set goalName(String name) { this.name = name; }
	String get goalName { return this.name; }

	set goalDesc(String desc) { this.desc = desc; }
	String get goalDesc { return this.desc; }

	void markComplete() { this.finished = true; }
	void markIncomplete() { this.finished = false; }

	void makeActive() { this.status = true; }
	void makeIdle() { this.status = false; }
}

class GoalViewer extends StatelessWidget
{
	Goal currentGoal;
	GoalViewer(this.currentGoal);
	@override
	Widget build(BuildContext context) {
		return ListTile(
			leading: Builder(
				builder: (BuildContext context) {
					return IconButton(
						icon: const Icon(Icons.check_circle_outline_rounded),
						onPressed: () => markGoalActive(currentGoal),
						color: Colors.green,
					);
				}
			),
			title: Text(currentGoal.goalName),
			subtitle: Text(currentGoal.goalDesc),
			enabled: currentGoal.status,
			dense: true,
			onLongPress: () => markGoalComplete(currentGoal),
			onTap: () => markGoalActive(currentGoal),
		);
  }
}



void addGoal(Goal newGoal) //adds new new goal
{
	String name = newGoal.name;
	//safecheck
	if(!userGoals.containsKey(name))
		userGoals[name] = newGoal;
}



void markGoalComplete(Goal finishedGoal)
{
	String name = finishedGoal.name;
	if(!userGoals.containsKey(name))
		return; //safecheck
	userGoals[name].markComplete();
}

void markGoalActive(Goal targetGoal)
{
	String name = targetGoal.name;
	if(userGoals.containsKey(name))
		userGoals[name].makeActive();
}

void removeGoal(Goal targetGoal)
{
	String name = targetGoal.name;
	if(userGoals.containsKey(name))
		userGoals.remove(name);
}

class ViewGoals extends StatelessWidget
{
	@override
	Widget build(BuildContext context) {
    return Scaffold(
			appBar:	AppBar(
				title: Text("My Goals"),
				automaticallyImplyLeading: true,
				centerTitle: true,
				leading: IconButton(icon:Icon(Icons.arrow_back),
					onPressed: () => Navigator.pop(context, false),
				),
			),
			body:
				ListView(
					children: <Widget>[
						Card(
							child: GoalViewer(userGoals[0]),
						)
					],
				)
		);
  }
}