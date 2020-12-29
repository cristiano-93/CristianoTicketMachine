package org.solent.com528.project.model.dto;

/**
 * @author Cristiano Local
 */
public class PaymentCalculator {
    public static boolean validNumber(long cardNumber) {
      return isValid(cardNumber);
   }
   
   public static boolean isValid(long cardNumber) {
      return (thesize(cardNumber) >= 13 && thesize(cardNumber) <= 16) && (prefixmatch(cardNumber, 4)
         || prefixmatch(cardNumber, 5) || prefixmatch(cardNumber, 37) || prefixmatch(cardNumber, 6))  //all of this is needed???
         && ((sumdoubleeven(cardNumber) + sumodd(cardNumber)) % 10 == 0);
   }
   
   public static int sumdoubleeven(long cardNumber) {
      int sum = 0;
      String number = cardNumber + "";
      for (int i = thesize(cardNumber) - 2; i >= 0; i -= 2)
         sum += getDigit(Integer.parseInt(number.charAt(i) + "") * 2);
      return sum;
   }
   
   public static int getDigit(int cardNumber) {
      if (cardNumber < 9)
         return cardNumber;
      return cardNumber / 10 + cardNumber % 10;
   }
   
   public static int sumodd(long cardNumber) {
      int sum = 0;
      String number = cardNumber + "";
      for (int i = thesize(cardNumber) - 1; i >= 0; i -= 2)
         sum += Integer.parseInt(number.charAt(i) + "");
      return sum;
   }
   
   public static boolean prefixmatch(long cardNumber, int d) {
      return getprefx(cardNumber, thesize(d)) == d;
   }
   
   public static int thesize(long d) {
      String number = d + "";
      return number.length();
   }
   
   public static long getprefx(long cardNumber, int k) {
      if (thesize(cardNumber) > k) {
         String number = cardNumber + "";
         return Long.parseLong(number.substring(0, k));
      }
      return cardNumber;
   }

}
