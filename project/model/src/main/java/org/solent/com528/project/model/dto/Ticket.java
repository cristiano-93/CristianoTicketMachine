package org.solent.com528.project.model.dto;

import java.util.Date;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * 
 *
 * @author cgallen
 */
@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class Ticket {

    private String startStation;
    
    private String endStation;
    
    private Integer endZone;

    private Double cost;

    private String encryptedHash;

    private Rate rate;

    private Date issueDate;
    

    public Integer getEndZone() {
        return endZone;
    }

    public void setEndZone(Integer endZone) {
        this.endZone = endZone;
    }
            

    public String getStartStation() {
        return startStation;
    }

    public void setStartStation(String startStation) {
        this.startStation = startStation;
    }
    
    public String getEndStation() {
        return endStation;
    }

    public void setEndStation(String endStation) {
        this.endStation = endStation;
    }

    public Double getCost() {
        return cost;
    }

    public void setCost(Double cost) {
        this.cost = cost;
    }

    public String getEncryptedHash() {
        return encryptedHash;
    }

    public void setEncryptedHash(String encryptedHash) {
        this.encryptedHash = encryptedHash;
    }

    public Rate getRate() {
        return rate;
    }

    public void setRate(Rate rate) {
        this.rate = rate;
    }

    public Date getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(Date issueDate) {
        this.issueDate = issueDate;
    }

    @Override
    public String toString() {
        return "Ticket{" + "startStation=" + startStation + ", cost=" + cost + ", encryptedHash=" + encryptedHash + ", rate=" + rate + ", issueDate=" + issueDate + '}';
    }



}
