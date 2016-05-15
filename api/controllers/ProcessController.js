/**
 * ProcessController
 *
 * @description :: Server-side logic for managing Processes
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {
	   process : function (req, res) {
           var CHILD = require('child_process');
           var goal = req.body.goal;
           var objfunction = req.body.objfunction;
           var constraints = req.body.constraints.split(";");

           console.log("Goal: " + goal);
           console.log("Objective Function: " + objfunction);
           console.log("Constraints: ");
           for (constraint in constraints) {
               console.log("   " + constraints[constraint])
           }

           if (goal == "maximize") {
               CHILD.execFile("Rscript", ["maximize.r"], function (err, stdout, stderr) {
                   res.ok(stdout);
               });
           }
           else if (goal == "minimize") {
               CHILD.execFile("Rscript", ["minimize.r"], function (err, stdout, stderr) {
                   res.ok(stdout);
               });
           }
           else {
               res.badRequest("Your goal is out of coverage area. Please try again later!");
           }
       }
};
