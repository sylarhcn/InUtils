//
//  NSDate+Utils.m
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */

- (NSString *)humanReadableString {
    NSUInteger daysAgo = [self daysAgoAgainstMidnight];
    NSString *dateString = nil;
    
    // date
    switch (daysAgo) {
        case 0:
            dateString = @"今天";
            break;
        case 1:
            dateString = @"昨天";
            break;
        case 2:
            dateString = @"前天";
            break;
        case 3:
            dateString = @"大前天";
            break;
        default: {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            if ([[NSDate date] getYear]==[self getYear]) {
                [dateFormatter setDateFormat:@"MM月dd日"];
            }
            else {
                [dateFormatter setDateFormat:@"yy年MM月dd日"];
            }
            dateString = [dateFormatter stringFromDate:self];

        }
    }
    
    // time
    NSString *timeString = nil;
    
    switch (daysAgo) {
        case 0:
        case 1:
        case 2:
        case 3: {
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"HH:mm"];
            
            timeString = [timeFormatter stringFromDate:self];
        }
            break;
        default: 
            break;
    }
    
    if (timeString!=nil) {
        return [NSString stringWithFormat:@"%@ %@", dateString, timeString];
    }
    else {
        return dateString;
    }
}

- (int)getDayNumOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    
    return range.length;
}

//获取年月日如:19871127.
- (NSString *)getFormatYearMonthDay
{
    NSString *string = [NSString stringWithFormat:@"%d%02d%02d",[self getYear],[self getMonth],[self getDay]];
    
    return string;
}

//返回当前月一共有几周(可能为4,5,6)
- (int )getWeekNumOfMonth
{
    return [[self endOfMonth] getWeekOfYear] - [[self beginningOfMonth] getWeekOfYear] + 1;
}

//该日期是该年的第几周
- (int )getWeekOfYear
{
    int i;
    int year = [self getYear];
    NSDate *date = [self endOfWeek];
    for (i = 1;[[date dateAfterDay:-7 * i] getYear] == year;i++) 
    {
    }
    return i;
}

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(int)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    // NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

    
    return dateAfterDay;
}

//month个月后的日期
- (NSDate *)dateafterMonth:(int)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

    
    return dateAfterMonth;
}

//获取日
- (NSUInteger)getDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];
    return [dayComponents day];
}

//获取月
- (NSUInteger)getMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];
    return [dayComponents month];
}

//获取年
- (NSUInteger)getYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];
    return [dayComponents year];
}

//获取小时
- (int )getHour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger hour = [components hour];
    return (int)hour;
}

//获取分钟
- (int)getMinute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger minute = [components minute];
    return (int)minute;
}

- (int )getHour:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [components hour];
    return (int)hour;
}

- (int)getMinute:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSInteger minute = [components minute];
    
    return (int)minute;
}

//在当前日期前几天
- (NSUInteger)daysAgo {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit) 
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    
    return [components day];
}

//午夜时间距今几天
- (NSUInteger)daysAgoAgainstMidnight {
    // get a midnight version of ourself:
    
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];

    
    return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
    return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
    
    NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
    NSString *text = nil;
    
    switch (daysAgo) {
        case 0:
            text = @"今天";
            break;
        case 1:
            text = @"昨天";
            break;
        case 2:
            text = @"前天";
            break;
        default:
            text = [NSString stringWithFormat:@"%d 天前", daysAgo];
    }
    return text;
}

//返回一周的第几天(周末为第一天)
- (NSUInteger)weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
    
    return [weekdayComponents weekday];
}

//转为NSString类型的
+ (NSDate *)dateFromString:(NSString *)string {
    return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:format];
    
    NSDate *date = [inputFormatter dateFromString:string];
    

    
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    /* 
     * if the date is in today, display 12-hour time with meridian,
     * if it is within the last 7 days, display weekday name (Friday)
     * if within the calendar year, display as Jan 23
     * else display as Nov 11, 2008
     */
    
    NSDate *today = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
                                                     fromDate:today];
    
    NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
    NSString *displayString = nil;
    
    // comparing against midnight
    if ([date compare:midnight] == NSOrderedDescending) {
        if (prefixed) {
            [displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
        } else {
            [displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
        }
        
    } else {
        // check if date is within last 7 days
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        [componentsToSubtract setDay:-7];
        
        NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
        
        
        if ([date compare:lastweek] == NSOrderedDescending) {
            
            [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
            
        } else {
            
            // check if same calendar year
            
            NSInteger thisYear = [offsetComponents year];
            
            
            
            NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
                                                
                                                           fromDate:date];
            
            NSInteger thatYear = [dateComponents year];
            
            if (thatYear >= thisYear) {
                
                [displayFormatter setDateFormat:@"MMM d"];
                
            } else {
                
                [displayFormatter setDateFormat:@"MMM d, yyyy"];
                
            }
            
        }
        
        if (prefixed) {
            
            NSString *dateFormat = [displayFormatter dateFormat];
            
            NSString *prefix = @"'on' ";
            
            [displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
            
        }
        
    }
    // use display formatter to return formatted date string
    
    displayString = [displayFormatter stringFromDate:date];
    

    
    return displayString;
    
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
    return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:format];
    
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    

    
    return timestamp_str;
}

- (NSString *)string {
    return [self stringWithFormat:[NSDate dbFormatString]];
    
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:dateStyle];
    [outputFormatter setTimeStyle:timeStyle];
    NSString *outputString = [outputFormatter stringFromDate:self];

    return outputString;
}

//返回周日的的开始时间
- (NSDate *)beginningOfWeek {
    
    // largely borrowed from "Date and Time Programming Guide for Cocoa"
    
    // we'll use the default calendar and hope for the best
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *beginningOfWeek = nil;
    
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
               
                           interval:NULL forDate:self];
    if (ok) {
        return beginningOfWeek;
        
    } 
    
    // couldn't calc via range, so try to grab Sunday, assuming gregorian style
    // Get the weekday component of the current date
    
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
     */
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    beginningOfWeek = nil;
    beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
    //normalize to midnight, extract the year, month, and day components and create a new date from those components.
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:beginningOfWeek];
    
    return [calendar dateFromComponents:components];
}

//返回当前天的年月日.
- (NSDate *)beginningOfDay {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
                                    
                                               fromDate:self];
    
    return [calendar dateFromComponents:components];
    
}

//返回该月的第一天
- (NSDate *)beginningOfMonth
{
    return [self dateAfterDay:-[self getDay] + 1];
}

//该月的最后一天
- (NSDate *)endOfMonth
{
    return [[[self beginningOfMonth] dateafterMonth:1] dateAfterDay:-1];
}

//返回当前周的周末
- (NSDate *)endOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    
    // to get the end of week for a particular date, add (7 - weekday) days
    
    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
    
    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    
    
    return endOfWeek;
}

+ (NSString *)dateFormatString {
    return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
    return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
    return @"yyyy-MM-dd HH:mm:ss";
}

// preserving for compatibility
+ (NSString *)dbFormatString {
    return [NSDate timestampFormatString];
}

//农历转换函数
+(NSString *)lunarForSolar:(NSDate *)solarDate {
    //天干名称
    NSArray *cTianGan = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸", nil];
    
    //地支名称
    NSArray *cDiZhi = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
    
    //属相名称
    NSArray *cShuXiang = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
    
    //农历日期名
    NSArray *cDayName = [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                         @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                         @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName = [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static int wCurYear,wCurMonth,wCurDay;
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //取当前公历年、月、日
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:solarDate];
    wCurYear = [components year];
    wCurMonth = [components month];
    wCurDay = [components day];
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    
    //生成农历天干、地支、属相
    NSString *szShuXiang = (NSString *)[cShuXiang objectAtIndex:((wCurYear - 4) % 60) % 12];
    NSString *szNongli = [NSString stringWithFormat:@"%@(%@%@)年",szShuXiang, (NSString *)[cTianGan objectAtIndex:((wCurYear - 4) % 60) % 10],(NSString *)[cDiZhi objectAtIndex:((wCurYear - 4) % 60) % 12]];
    
    //生成农历月、日
    NSString *szNongliDay;
    if (wCurMonth < 1){
        szNongliDay = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]]; 
    }
    else{
        szNongliDay = (NSString *)[cMonName objectAtIndex:wCurMonth]; 
    }
    
    NSString *lunarDate = [NSString stringWithFormat:@"%@ %@月 %@",szNongli,szNongliDay,(NSString *)[cDayName objectAtIndex:wCurDay]];
    
    return lunarDate;
}

@end
