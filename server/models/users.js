var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var usersSchema = new Schema({
    name: String
});

//mongoose.model('users', usersSchema);

module.exports = function(){

    mongoose.model('cat',{name:String});

    mongoose.model('userasdf',usersSchema);

    mongoose.model('comment',{
        date: Date,
        username:String,
        comment: String
    });
};