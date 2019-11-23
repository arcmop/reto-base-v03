/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ibm.testautomationlab01;

import java.io.File;
import junit.framework.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.phantomjs.PhantomJSDriver;

/**
 *
 * @author mastermind
 */
public class FunctionalTest01 {

    @Before
    public void testBefore() {

    }

    //@Test
    public void test01() throws InterruptedException {
        System.setProperty("webdriver.chrome.driver", "C:\\Aplicaciones\\chromedriver_win32\\chromedriver.exe");
        WebDriver chromeExecutor = new ChromeDriver();

        chromeExecutor.get("http://localhost:8011/qaautomationlab");
        chromeExecutor.findElement(By.id("txt01")).click();
        chromeExecutor.findElement(By.id("txt01")).sendKeys("10");
        chromeExecutor.findElement(By.id("txt02")).click();
        chromeExecutor.findElement(By.id("txt02")).sendKeys("20");
        chromeExecutor.findElement(By.id("btnsum")).click();

        WebElement we = chromeExecutor.findElement(By.id("txtresult"));

        try {
            Thread.sleep(3000);

            Assert.assertEquals("30", we.getAttribute("value"));
        } catch (Exception e) {
        } finally {
            chromeExecutor.quit();
        }
    }

    //@Test
    public void test02() throws InterruptedException {
        File file = new File("C:\\Aplicaciones\\phantomjs-2.1.1-windows\\bin\\phantomjs.exe");
        System.setProperty("phantomjs.binary.path", file.getAbsolutePath());

        WebDriver phamJSExecutor = new PhantomJSDriver();

        phamJSExecutor.get("http://localhost:8011/qaautomationlab");
        phamJSExecutor.findElement(By.id("txt01")).click();
        phamJSExecutor.findElement(By.id("txt01")).sendKeys("80");
        phamJSExecutor.findElement(By.id("txt02")).click();
        phamJSExecutor.findElement(By.id("txt02")).sendKeys("20");
        phamJSExecutor.findElement(By.id("btnsum")).click();

        WebElement we = phamJSExecutor.findElement(By.id("txtresult"));

        try {
            Assert.assertEquals("100", we.getAttribute("value"));
        } catch (Exception e) {
        } finally {
            phamJSExecutor.quit();
        }
    }
}
