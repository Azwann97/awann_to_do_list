# etiqa_to_do_list

A new Flutter project.

developer: AZWANN BIN ABU BAKAR

plugin used:
intl: handling date time variable in this project
provider: manage app state
sqflite: handling CRUD function in the app
path: support join statement for CRUD function

dir:
controller : contains functions that will handle most of the action in the app
model : contains to-do list model
service : contains sqlite function to mange CRUD operation
view: contains all of the ui for the app & some small function

testing guide:

Create: after user click on create new button inside to-do list details page, app will add the new to-do details into db.

Retrieve: everytime user redirect to To-Do list page or complete (create/update/delete), app will retrieve updated list from db.

Update: after user click one of the to-do list card, user will redirect to to-do list details page to allow the update the details. Then user can click on update button to update to-do details.

Delete: in to-do list page, user can slide to-do card to the right to delete to-do list from db
