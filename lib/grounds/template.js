(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['template.html'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1, stack2;
  buffer += "\n  <li class='resource'>\n    <h2>";
  foundHelper = helpers.name;
  stack1 = foundHelper || depth0.name;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "name", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</h2>\n    <ul class='operations'>\n      ";
  foundHelper = helpers.operation;
  stack1 = foundHelper || depth0.operation;
  stack2 = helpers.each;
  tmp1 = self.program(2, program2, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </ul>\n  </li>\n  ";
  return buffer;}
function program2(depth0,data) {
  
  var buffer = "", stack1, stack2;
  buffer += "\n      <li class='operation ";
  foundHelper = helpers.httpMethod;
  stack1 = foundHelper || depth0.httpMethod;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "httpMethod", { hash: {} }); }
  buffer += escapeExpression(stack1) + "'>\n        <header>\n          <h3>\n            <a class='";
  foundHelper = helpers.nickname;
  stack1 = foundHelper || depth0.nickname;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "nickname", { hash: {} }); }
  buffer += escapeExpression(stack1) + "'>";
  foundHelper = helpers.nickname;
  stack1 = foundHelper || depth0.nickname;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "nickname", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</a>\n          </h3>\n          <ul class='options'>\n            <li>\n              ";
  foundHelper = helpers.summary;
  stack1 = foundHelper || depth0.summary;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "summary", { hash: {} }); }
  buffer += escapeExpression(stack1) + "\n              <li></li>\n            </li>\n          </ul>\n        </header>\n        <form>\n          <span class='nickname'>";
  foundHelper = helpers.nickname;
  stack1 = foundHelper || depth0.nickname;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "nickname", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</span>\n          <span class='path'>";
  foundHelper = helpers.path;
  stack1 = foundHelper || depth0.path;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "path", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</span>\n          <table>\n            <thead>\n              <tr>\n                <td>Parameter</td>\n                <td>Value</td>\n                <td>Description</td>\n              </tr>\n            </thead>\n            <tbody>\n              ";
  foundHelper = helpers.parameter;
  stack1 = foundHelper || depth0.parameter;
  stack2 = helpers.each;
  tmp1 = self.program(3, program3, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n            </tbody>\n          </table>\n        </form>\n        <div class='response'></div>\n      </li>\n      ";
  return buffer;}
function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n              <tr>\n                <td>";
  foundHelper = helpers.name;
  stack1 = foundHelper || depth0.name;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "name", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</td>\n                <td>";
  foundHelper = helpers.value;
  stack1 = foundHelper || depth0.value;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "value", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</td>\n                <td>";
  foundHelper = helpers.value;
  stack1 = foundHelper || depth0.value;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "value", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</td>\n              </tr>\n              ";
  return buffer;}

  buffer += "<h1>";
  foundHelper = helpers.basePath;
  stack1 = foundHelper || depth0.basePath;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "basePath", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</h1>\n<ul class='resources'>\n  ";
  foundHelper = helpers.resource;
  stack1 = foundHelper || depth0.resource;
  stack2 = helpers.each;
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</ul>";
  return buffer;});
})();