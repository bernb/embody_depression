function [mw_gesamt, mw_beine, mw_arme, mw_kopf, mw_rumpf] = calc_mean_activation(reize, mask)
%CALC_MEAN_ACTIVATION calculate mean activation value (per person and emotion)

    % values for rows and columns are hard-coded and depend on image layout
    zeilen = 522;
    spalten = 171;
    
    mw_gesamt = zeros(7,1);
    mw_beine = zeros(7,1);
    mw_arme = zeros(7,1);
    mw_rumpf = zeros(7,1);
    mw_kopf = zeros(7,1);
    
    % Calculate sums
    for condit=1:7
        for i=1:zeilen
            for j=1:spalten
                mw_gesamt(condit) = mw_gesamt(condit) + reize(i,j,condit);
                if (i>289) && (j>33) && (j<spalten-32) % Beine
                    mw_beine(condit) = mw_beine(condit) + reize(i,j,condit);
                end
                if (j < 34) || (j > spalten - 34) % Arme
                    mw_arme(condit) = mw_arme(condit) + reize(i,j,condit);
                end
                if (i >= 77) && (i <=289) && (j >=34) &&(j<=spalten-33) % Rumpf
                    mw_rumpf(condit) = mw_rumpf(condit) + reize(i,j,condit);
                end
                if (i <=76) % Kopf
                    mw_kopf(condit) = mw_kopf(condit) + reize(i,j,condit);
                end
            end
        end
    end
    
    % Count all pixels
    anzahl_pixel_gesamt=0;
    anzahl_pixel_beine=0;
    anzahl_pixel_arme=0;
    anzahl_pixel_kopf=0;
    anzahl_pixel_rumpf=0;
    for i=1:zeilen
        for j=1:spalten
            if mask(i,j)> 128
                anzahl_pixel_gesamt=anzahl_pixel_gesamt+1;
                if (i>289) && (j>33) && (j<spalten-32) % Beine
                    anzahl_pixel_beine = anzahl_pixel_beine + 1;
                end
                if (j < 34) || (j > spalten - 34) % Arme
                    anzahl_pixel_arme = anzahl_pixel_arme + 1;
                end
                if (i >= 77) && (i <=289) && (j >=34) &&(j<=spalten-33) % Rumpf
                    anzahl_pixel_rumpf = anzahl_pixel_rumpf + 1;
                end
                if (i <=76) % Kopf
                    anzahl_pixel_kopf = anzahl_pixel_kopf + 1;
                end
            end
        end
    end
    
    mw_gesamt = mw_gesamt/anzahl_pixel_gesamt;
    mw_beine = mw_beine/anzahl_pixel_beine;
    mw_arme = mw_arme/anzahl_pixel_arme;
    mw_kopf = mw_kopf/anzahl_pixel_kopf;
    mw_rumpf = mw_rumpf/anzahl_pixel_rumpf;
end

