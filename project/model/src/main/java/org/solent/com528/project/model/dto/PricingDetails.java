package org.solent.com528.project.model.dto;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;
import org.solent.com528.project.impl.dao.jaxb.PriceCalculatorDAOJaxbImpl;

@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class PricingDetails {
    PriceCalculatorDAOJaxbImpl priceCalculatorDAOJaxb;

    private Double peakPricePerZone = 2.5;

    private Double offpeakPricePerZone = 5.0;

    @XmlElementWrapper(name = "priceBandList")
    @XmlElement(name = "priceBand")
    private List<PriceBand> priceBandList;

    public PricingDetails() {
       
        priceBandList = new ArrayList<PriceBand>();
        
        PriceBand priceBand1 = new PriceBand();
        priceBand1.setRate(Rate.OFFPEAK);
        priceBand1.setHour(0);
        priceBand1.setMinutes(0);
        priceCalculatorDAOJaxb.addPriceBand(priceBand1);

        PriceBand priceBand2 = new PriceBand();
        priceBand2.setRate(Rate.PEAK);
        priceBand2.setHour(7);
        priceBand2.setMinutes(0);
        priceCalculatorDAOJaxb.addPriceBand(priceBand2);

        PriceBand priceBand3 = new PriceBand();
        priceBand3.setRate(Rate.OFFPEAK);
        priceBand3.setHour(10);
        priceBand3.setMinutes(0);
        priceCalculatorDAOJaxb.addPriceBand(priceBand3);

        PriceBand priceBand4 = new PriceBand();
        priceBand4.setRate(Rate.PEAK);
        priceBand4.setHour(16);
        priceBand4.setMinutes(0);
        priceCalculatorDAOJaxb.addPriceBand(priceBand4);

        PriceBand priceBand5 = new PriceBand();
        priceBand5.setRate(Rate.OFFPEAK);
        priceBand5.setHour(19);
        priceBand5.setMinutes(0);
        priceCalculatorDAOJaxb.addPriceBand(priceBand5);
    }

    public Double getPeakPricePerZone() {
        return peakPricePerZone;
    }

    public void setPeakPricePerZone(Double peakPricePerZone) {
        this.peakPricePerZone = peakPricePerZone;
    }

    public Double getOffpeakPricePerZone() {
        return offpeakPricePerZone;
    }

    public void setOffpeakPricePerZone(Double offpeakPricePerZone) {
        this.offpeakPricePerZone = offpeakPricePerZone;
    }

    public List<PriceBand> getPriceBandList() {
        return priceBandList;
    }

    public void setPriceBandList(List<PriceBand> priceBandList) {
        this.priceBandList = priceBandList;
    }

    @Override
    public String toString() {
        StringBuffer sb = new StringBuffer("PricingDetails{" + "peakPricePerZone=" + peakPricePerZone + ", offpeakPricePerZone=" + offpeakPricePerZone + "\n priceBandList:\n");

        for (PriceBand priceBand : priceBandList) {
            sb.append("   " + priceBand.toString() + "\n");
        }

        sb.append("}");

        return sb.toString();

    }

}
