//
//  KDCnCal.swift
//  ChineseCalendar
//
//  Created by 斌 on 14-7-15.
//  Copyright (c) 2014年 斌. All rights reserved.
//

import UIKit

class KDCnCal: NSObject {

    let startYear = 2001
    
    func chunJie (years : Int ) -> NSString{
        
        //以下以2001为起点，到2017年为例
        //闰月可到百度百科自己查，http://baike.baidu.com/view/19617.htm
        
        //设置闰月
        var leapMont : NSArray = ["2001","2004","2006","2009","2012","2014","2017"]
        
        //闰年、平年
        var leapYear = 0,commonYear = 0
        
        //闰月年份。
        for i in 0...(leapMont.count)-1 {
            let temp  = (leapMont.objectAtIndex(i) as NSString ).integerValue
            if ( years > temp) {
                leapYear++
            }
        }
        
        //平年。
        commonYear = years - startYear - leapYear
        
        NSLog("年份 = \(years) 闰年 = \(leapYear) 平年 = \(commonYear)")
        
        
        //计算方法：平年提前11天左右，闰年推迟19天左右。
        //2010年过年是1月24号。推荐用1月的年份做启始年。
        var days = 0
        
        if (years > startYear) {//大于2001年
            days = 24 + 19 * leapYear - 11 * commonYear
            
        }else if(years == startYear){//2001年
            days = 24
        }else{//超出开始时间,其实也是我懒得写= =！
            NSLog("超出开始时间")
        }

        var cacheStr : NSString
        if (days > 31) {//超过1月31
            cacheStr = NSString(format: "%d-02-%02d",years,days-31)
            
        }else{
            cacheStr = NSString(format: "%d-01-%2d",years,days)
            

        }

        //转农历
        var date : NSString = self.getChineseCalendarWithString(cacheStr, formatString:"yyyy-MM-dd")
        
        //补缺一天时间
        if (date.isEqualToString("12 30")) {
            days++
        }else if (date.isEqualToString("1 2")){
            days--
        }
        
        //重新组织。每年过年时候的公历
        if (days > 31) {
            cacheStr = NSString(format: "%d-02-%02d",years,days-31)
            
        }else{
            cacheStr = NSString(format: "%d-01-%2d",years,days)
        }
        
        return cacheStr;

    }
    
    
    
    func getChineseCalendarWithString ( strDate : NSString ,formatString strFormat : NSString) -> NSString{
    
        var formatter : NSDateFormatter = NSDateFormatter()

        var timeZone : NSTimeZone = NSTimeZone(abbreviation : "GTM")
    
        formatter.timeZone = timeZone
        
        formatter.dateFormat = strFormat
        
        var dateTime : NSDate = formatter.dateFromString(strDate)
        
        var localeCalendar : NSCalendar = NSCalendar(calendarIdentifier:NSChineseCalendar)

        var unitFlags : NSCalendarUnit = NSCalendarUnit.MonthCalendarUnit |  NSCalendarUnit.DayCalendarUnit
        
        var localeComp : NSDateComponents = localeCalendar.components(unitFlags, fromDate: dateTime)
        
        var Calendar : NSString = NSString(format: "%d %d",localeComp.month,localeComp.day)
        
        return Calendar;

    }
    
    /*
    2001年春节日期，过年时间：2001年1月24日
    2002年春节日期，过年时间：2002年2月12日
    2003年春节日期，过年时间：2003年2月1日
    2004年春节日期，过年时间：2004年1月22日
    2005年春节日期，过年时间：2005年2月9日
    2006年春节日期，过年时间：2006年1月29日
    2007年春节日期，过年时间：2007年2月18日
    2008年春节日期，过年时间：2008年2月7日
    2009年春节日期，过年时间：2009年1月26日
    2010年春节日期，过年时间：2010年2月14日
    2011年春节日期，过年时间：2011年2月3日
    2012年春节日期，过年时间：2012年1月23日
    2013年春节日期，过年时间：2012年2月10日
    2014年春节日期，过年时间：2014年1月31日
    2015年春节日期，过年时间：2015年2月19日
    2016年春节日期，过年时间：2016年2月8日
    2017年春节日期，过年时间：2017年1月28日
    2018年春节日期，过年时间：2018年2月16日
    2019年春节日期，过年时间：2019年2月5日
    2020年春节日期，过年时间：2020年1月25日
    */
    
    func getChineseCalendarWithString2(Date : NSString) -> NSString{
    
        //取年份，月份，日期
        var chineseYears : NSString ,chineseMonths : NSString ,chineseDays : NSString
        var DateAr : NSArray = Date.componentsSeparatedByString(" ")
        
        NSLog("农历：%@",Date)
        chineseYears = DateAr.objectAtIndex(0) as NSString
        chineseMonths = DateAr.objectAtIndex(1) as NSString
        chineseDays = DateAr.objectAtIndex(2) as NSString
        
        //设置闰年
        let leapYearsAr : NSArray = ["2001","2004","2006","2009","2012","2014","2017"]
        //设置闰月
        let leapMonthsAr : NSArray = ["四月","二月","七月","五月","四月","九月","六月"]
        
        //天数,闰月
        var day : Int = 0, leapMonth : Int
        var month = self.getIntValue(chineseMonths)
        
        //确定是否带闰月,有就将闰月读出来
        for i in 0...(leapYearsAr.count)-1{
            if (chineseYears.isEqualToString(leapYearsAr.objectAtIndex(i) as NSString)){
                NSLog("%@年有闰%@",chineseYears,leapMonthsAr.objectAtIndex(i) as NSString)
                leapMonth = self.getIntValue(leapMonthsAr.objectAtIndex(i) as NSString)
            }
        }
        
        if (month > leapMonth && leapMonth){//有包含闰月
            //天数+闰月+剩下天数
            day = 30 + self.getIntValue(chineseDays);
        }else{//没有包含闰月，那么是否该月就是闰月
            if (chineseMonths.hasPrefix("闰")) {
                //天数+普通月份+带闰天数
                day = 30 + self.getIntValue(chineseDays);
            }else{
                day = self.getIntValue(chineseDays) ;
            }
        }

        //正常年份
        //农历大月：1、3、5、6、8、10、12(30天)
        for i in 1...month-1 {
            if (i<6) {
                if (i%2==1) {
                    day=day+30
                }else{
                    day=day+29
                }
            }else{
                if (i%2==0) {
                    day=day+30
                }else{
                    day=day+29
                }
            }
        }
        
        NSLog("一共有%d月 共%d天",month,day)
        
        //==========================
        
        //取本年份，过年时候公历日期
        var chunJie : NSString = self.chunJie(chineseYears.intValue)
        var chunJieAr : NSArray = chunJie.componentsSeparatedByString("-")
        NSLog("春节公历 %@",chunJie)
        
        var chujiey : Int = (chunJieAr.objectAtIndex(0) as NSString).intValue
        var chujiem : Int = (chunJieAr.objectAtIndex(1) as NSString).intValue
        var chujied : Int = (chunJieAr.objectAtIndex(2) as NSString).intValue

        //补齐一个月,一般公历春节不是1月就是2月
        var sM : Int = 0
        if (chujiem==1) {
            //一月份
            chujied=31-chujied
            sM=2
        }else{//二月份
            
            //是否闰年
            if (chujiey%4==0) {
                chujied=29-chujied
            }else{
                chujied=28-chujied
            }
            sM=3
        }
        day=day-chujied
        NSLog("剩余%d天",day)
        
        
        //大月21：1、3、5、7、8、10、12
        for (; sM<14; sM++) {
            if (sM<8) {
                if (sM%2==1) {
                    day = day-31;
                    
                    if (sM==1){
                        if (chujiey % 4==0 && day < 29) {
                            return NSString(format: "%d-%d-%d",chujiey,sM,day-1)
                        }else if (chujiey % 4 != 0 && day < 28){
                            return NSString(format: "%d-%d-%d",chujiey,sM,day-1)
                        }
                    }else if (sM==7){
                        if (day<31){
                            return NSString(format: "%d-%d-%d",chujiey,sM,day-1)
                        }
                    }
                    
                }else{
                    if (sM==2){
                        if (chujiey % 4==0) {
                            day = day - 29;
                        }else{
                            day = day - 28;
                        }
                    }else{
                        day = day - 30;
                    }
                    
                    if (day<31){
                        return NSString(format: "%d-%d-%d",chujiey,sM,day-1)
                    }
                }
            }else if (sM<12) {
                if (sM%2==0) {
                    day=day-31;
                    
                    if (day<30){
                        return NSString(format: "%d-%d-%d",chujiey,sM,day-1)
                    }
                }else{
                    day=day-30;
                    
                    if (day<31){
                        return NSString(format: "%d-%d-%d",chujiey,sM,day-1)
                    }
                }
            }else{
                day=day-31;
                if ( day<31) {
                    return NSString(format: "%d-%d-%d",chujiey+1,sM-11,day-1)
                }
            }
        }
        
        return "error"
        
    }
    

    
    func getIntValue (var date : NSString ) -> Int{
    
        date = date.stringByReplacingOccurrencesOfString("闰", withString:"")
        
        //月份数组
        var Months : NSArray = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月",
        "九月", "十月", "十一月", "腊月"]
        
        //日数组
        var Days : NSArray = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
            "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
            "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十",]


        if (date.hasSuffix("月")){
            for i in 0...(Months.count)-1{
                if (date.isEqualToString( Months.objectAtIndex(i) as NSString )){
                    return i+1;
                }
            }
        }else{
            for i in 0...(Days.count)-1{
                if (date.isEqualToString(Days.objectAtIndex(i) as NSString )){
                    return i+1;
                }
            }
        }

        return 0;
    }
}
