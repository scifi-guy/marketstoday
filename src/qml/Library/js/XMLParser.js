/*
@version: 0.2
@author: Sudheer K. <scifi1947 at gmail.com>
@license: GNU General Public License
*/


function logMessage(strMessage){
    if (logUtility){
        logUtility.logMessage(strMessage);
    }
    else{
        console.log(strMessage);
    }
}

