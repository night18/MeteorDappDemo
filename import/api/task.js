import { Meteor } from 'meteor/meteor';
import { Mongo } from 'meteor/mongo';

export const Tasks = new Mongo.Collection('task');

Meteor.methods({
	'tasks.insert'(_addr){
		Tasks.insert({
			address:_addr,
			createdAt: new Date()
		});
	}

});