/*
@version: 0.4
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/

function isTodayAWeekDay(){
    var dayOfWeek = (new Date()).getDay();
    var isWeekDay = (dayOfWeek == 0 || dayOfWeek == 6)? false : true;
    return isWeekDay;
}
