import "package:flutter/material.dart";

var userGoals = new Map();

void main()
{

	runApp(MyApp());
}


Goal testGoal = new Goal("Test", "This is my test goal case!!");

class MyApp extends StatelessWidget
{
	@override
	Widget build(BuildContext context) {
		addGoal(testGoal);
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

class GoalViewer extends StatefulWidget
{
	Goal currentGoal;
	GoalViewer(this.currentGoal);
	@override
	State<StatefulWidget> createState() { return _GoalViewerState(currentGoal); }
}

class _GoalViewerState extends State<GoalViewer>
{
	Goal currentGoal;
	_GoalViewerState(this.currentGoal);

	@override
	Widget build(BuildContext context) {
		return ListTile(
			leading: Icon(
				currentGoal.finished ? Icons.check_box : Icons.cancel,
				color: currentGoal.finished ? Colors.green: Colors.red,
			),
			// leading: IconButton(
			// 	icon: currentGoal.finished ? const Icon(Icons.check) : Icon(Icons.cancel),
			// 	color: currentGoal.finished ? Colors.green : Colors.red,
			// 	onPressed: () => {},
			// ),
			title: Text(currentGoal.goalName),
			subtitle: Text(currentGoal.goalDesc),
			isThreeLine: true,
			enabled: true,
			dense: false,
			tileColor: Colors.white12,
			selectedTileColor: Colors.blueAccent,
			selected: currentGoal.status,
			onLongPress: () => {
				setState(() { currentGoal.finished = !currentGoal.finished; })
			},
			onTap: () => {
				setState(() { currentGoal.status = !currentGoal.status; })
			},
			trailing: IconButton(
				icon: Icon(Icons.menu),
				color: Colors.blueGrey,
				onPressed: () => { PopupMenuButton<> },
			),
		);
  }
}

Text isActive(Goal g)
{
	if(g.status)
		return Text("Goal Active!");
	return Text("Goal Inactive");
}

void addGoal(Goal newGoal) //adds new new goal
{
	String name = newGoal.name;
	//safecheck
	if(!userGoals.containsKey(name))
		userGoals[name] = newGoal;
}

void markGoalIncomplete(Goal unfinishedGoal)
{
	String name = unfinishedGoal.name;
	if(userGoals.containsKey(name)) //safecheck
		userGoals[name].markIncomplete();
}

void markGoalComplete(Goal finishedGoal)
{
	String name = finishedGoal.name;
	if(userGoals.containsKey(name)) //safecheck
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

class ViewGoals extends StatefulWidget
{
	@override
	State<StatefulWidget> createState() { return _ViewGoalsState(); }
}

class _ViewGoalsState extends State<ViewGoals>
{
	@override
	Widget build(BuildContext context) {
		var keys = userGoals.keys.toList();
    return Scaffold(
			appBar:	AppBar(
				title: Text("My Goals"),
				automaticallyImplyLeading: true,
				centerTitle: true,
					actions: <Widget>[
						IconButton(icon: Icon(Icons.add), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(title: "Test")))),
					],
				leading: IconButton(icon:Icon(Icons.arrow_back),
					onPressed: () => Navigator.pop(context, false),
				),

			),
			body:
				ListView.builder(
					itemCount: keys.length,
						itemBuilder: (BuildContext context, int index) {
							return GoalViewer(userGoals[keys[index]]);
						}
				)
		);
  }
}