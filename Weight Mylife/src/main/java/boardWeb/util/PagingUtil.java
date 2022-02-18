// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   PagingUtil.java

package boardWeb.util;


public class PagingUtil
{

    public PagingUtil()
    {
        cntPage = 5;
    }

    public PagingUtil(int total, int nowPage, int perPage)
    {
        cntPage = 5;
        setNowPage(nowPage);
        setPerPage(perPage);
        setTotal(total);
        calcLastPage(total, perPage);
        calcStartEndPage(nowPage, cntPage);
        calcStartEnd(nowPage, perPage);
    }

    public void calcStartEnd(int nowPage, int perPage)
    {
        int end = nowPage * perPage;
        int start = (end - perPage) + 1;
        setEnd(end);
        setStart(start);
    }

    public void calcStartEndPage(int nowPage, int cntPage)
    {
        int endPage = (int)Math.ceil((double)nowPage / (double)cntPage) * cntPage;
        if(getLastPage() < endPage)
            setEndPage(getLastPage());
        else
            setEndPage(endPage);
        int startPage = (endPage - cntPage) + 1;
        if(startPage < 1)
            startPage = 1;
        setStartPage(startPage);
    }

    public void calcLastPage(int total, int perPage)
    {
        int lastPage = (int)Math.ceil((double)total / (double)perPage);
        setLastPage(lastPage);
    }

    public int getNowPage()
    {
        return nowPage;
    }

    public void setNowPage(int nowPage)
    {
        this.nowPage = nowPage;
    }

    public int getStartPage()
    {
        return startPage;
    }

    public void setStartPage(int startPage)
    {
        this.startPage = startPage;
    }

    public int getEndPage()
    {
        return endPage;
    }

    public void setEndPage(int endPage)
    {
        this.endPage = endPage;
    }

    public int getTotal()
    {
        return total;
    }

    public void setTotal(int total)
    {
        this.total = total;
    }

    public int getPerPage()
    {
        return perPage;
    }

    public void setPerPage(int perPage)
    {
        this.perPage = perPage;
    }

    public int getLastPage()
    {
        return lastPage;
    }

    public void setLastPage(int lastPage)
    {
        this.lastPage = lastPage;
    }

    public int getStart()
    {
        return start;
    }

    public void setStart(int start)
    {
        this.start = start;
    }

    public int getEnd()
    {
        return end;
    }

    public void setEnd(int end)
    {
        this.end = end;
    }

    private int nowPage;
    private int startPage;
    private int endPage;
    private int total;
    private int perPage;
    private int lastPage;
    private int start;
    private int end;
    private int cntPage;
}
