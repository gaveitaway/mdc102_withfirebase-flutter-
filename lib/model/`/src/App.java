import java.util.Scanner;

public class Report8 {
public static boolean checknum(String str) { 
    return str.matches("\\d+");// 정규 표현식으로 숫자가 아니면 안됨. 
  }
public static void main(String[] args) {
      Scanner keyboard = new Scanner(System.in);
      while(true) {
 System.out.println("Enter time in 24-hour notation:");
 String time = keyboard.nextLine();
 String noon = "AM";
      // 우선 입력을받고 이를 : 단위로 끊어서 시간 분으로 나눠 저장한다 . 이 값이 
 String[] newtime = time.split(":");
 try {
 //checknum 정규식을 이용해  이 값들이 숫자 두개로 된 값들인지 판단 
if(!checknum(newtime[0]) || !checknum(newtime[1]))
throw new TimeFormatException();// throw
int hour = Integer.parseInt(newtime[0]);
     //int 형으로 바꿔주어야 range 체크가 가능하다 
 String mtemp = newtime[1];
      // 분이 10분이하일때 경우를 대비해서 string 값 미리 저장 
int minute = Integer.parseInt(newtime[1]);
if(hour >= 24 || hour < 0 || minute > 60 || minute < 0) 
 throw new TimeFormatException();
                                
    //hour이 12를 넘어가면 24시간 단위 -> 
 if(hour >= 12) {
 hour -= 12;
 noon = "PM"; 
  }
System.out.println("That is the same as");
//temp는 0이 들어갈걸 대비해서 String 그대로 출력해주기   
System.out.println(hour+":"+mtemp +" " + noon);                                
 System.out.println("Again? (y/n)");
  if(keyboard.nextLine().equals("n")) {
 System.out.println(" End of program ");
  break;
 }
 } catch(TimeFormatException e) {
 System.out.println("There is no such time as " + time);
 System.out.println("Try again ");                                
                        }
                        
                }
keyboard.close();
        }
       //숫자가 아닌 경우는 예외처리  
        
}
class TimeFormatException extends Exception {}